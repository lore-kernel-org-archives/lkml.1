Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZGVVhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZGVVhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZGVVhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:37:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54969 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZGVVhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:37:52 -0400
Date: Wed, 22 Jul 2009 17:37:46 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GART_IOMMU without AGP
Message-ID: <20090722213746.GA20241@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org
References: <200907221926.50397.pavel@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907221926.50397.pavel@pavlinux.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 07:26:49PM +0400, Pavel Vasilyev wrote:
 > In the kernel configuration, if I choose x86_64 and PCI, then choose the item
 > "Garth IOMMU support", which, in turn, chooses not to switch off, support for
 > AGP. But many IOMMU system does not have AGP bus.
 
The lack of AGP slots doesn't mean a lack of AGP bus.
It's part of the K8 on-CPU northbridge.

	Dave

