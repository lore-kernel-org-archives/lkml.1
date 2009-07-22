Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZGVWZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZGVWZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZGVWZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:25:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbZGVWZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:25:06 -0400
Date: Wed, 22 Jul 2009 18:25:01 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Message-ID: <20090722222501.GA20860@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
References: <200907221926.50397.pavel@pavlinux.ru> <20090722213746.GA20241@redhat.com> <200907230158.15417.pavel@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907230158.15417.pavel@pavlinux.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 01:58:06AM +0400, Pavel Vasilyev wrote:
 > On Thursday 23 July 2009 01:37:46 Dave Jones wrote:
 > > The lack of AGP slots doesn't mean a lack of AGP bus.
 > > It's part of the K8 on-CPU northbridge.
 > 
 > Fine. But if I do not have AGP-card, why do I need the support of bus AGP? :)
 > It may allow the user to the toggle on or off when needed.

For those that _do_ have an AGP bus, it's mandatory, as the
aperture needs to be shared between IOMMU and video.

Removing the select creates a potential for people to load video drivers
that don't come with the kernel to corrupt data as soon as something
writes using the IOMMU.

For those that don't have an agp bus, it costs about 20k of code.
Is this really that big a concern ?

	Dave

