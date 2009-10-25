Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZJYSaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZJYSaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 14:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZJYSae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 14:30:34 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:54499 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbZJYSac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 14:30:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: udev in kernel source?
Date: Sun, 25 Oct 2009 19:30:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200910251834.06321.Martin@lichtvoll.de>
In-reply-To: <200910251834.06321.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910251930.36658.elendil@planet.nl>
X-OriginalArrivalTime: 25 Oct 2009 18:30:37.0044 (UTC) FILETIME=[3F1CFB40:01CA55A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Would that qualify as a reason to put it there and have make-kpkg / make
> deb / make rpm spit out a udev package as well?

How would that help?

It will result in udev more frequently being incompatible with user space. 
It also will increase the chance of failure if you switch between older 
and newer kernel versions.

IMO udev should primarily ensure compatibility with user space. The kernel 
should provide sufficient backwards compatibility to support older udev 
versions.

Sure, there will be cut-off points (one of which you seem to have hit 
here), but in general it's a lot easier to ensure a kernel is compatible 
with your current version of udev than ensuring random upstream versions 
of udev are compatible with your userland (especially if you're running 
the stable version of a distro).

Just my take on this issue.

Cheers,
FJP
