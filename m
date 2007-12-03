Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbXLCRTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbXLCRTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXLCRTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:19:46 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60270 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbXLCRTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:19:45 -0500
Date: Mon, 3 Dec 2007 18:19:44 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: overdue items in feature-removal-schedule
In-Reply-To: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0712031812170.11746@fbirervta.pbzchgretzou.qr>
References: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 3 2007 11:58, Erez Zadok wrote:
>
>What:	remove EXPORT_SYMBOL(kernel_thread)
>When:	August 2006
>
>One feature (removal of sys_sysctl) is listed for September 2010: are we
>really able to predict the future with this much accuracy?
>
>When, if at all, will those future/overdue features be removed for real?
>Have any of them been removed already?  It's very important to developers to
>have more accurate removal schedule for planning purposes.
>
>I think setting dates on feature removal isn't compatible with the current
>model of kernel code development, b/c despite our best efforts, it's hard to
>predict the precise release of the next 2.6.(x+1) kernel.

The release dates of Linux kernels are much more deterministic than
the removal dates in feature-removal-schedule.txt are accurate.

The reason I see for this is that many list readers do not object
patches that extend frs.txt, but there is always 'a lot' of
resistance when actually attempting to remove code. raw.ko is
probably the best example.

This kinda defeats the purpose of frs.txt. If subsys maintainers do
not croak when they see patches that add to frs.txt (assuming the
maintainers see the patches, to be fair), I take it they agree to
removing the feature soon. If not, the textfile should probably be
renamed to features-we-would-like-to-get-rid-of-sooner-or-later.txt.
