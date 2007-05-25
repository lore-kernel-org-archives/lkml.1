Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbXEYALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbXEYALW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXEYALN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:11:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49264 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750933AbXEYALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:11:12 -0400
Date: Fri, 25 May 2007 01:14:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.22-rc1-mm1: IDE compile error
Message-ID: <20070525011403.20e77ee7@the-village.bc.nu>
In-Reply-To: <4656284D.7080709@zytor.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	<20070516185552.GA4086@stusta.de>
	<200705240145.38055.bzolnier@gmail.com>
	<20070524115549.01c0e1ca@the-village.bc.nu>
	<4656284D.7080709@zytor.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > It thus needs fixing not removing.
> > 
> 
> Opinions, anyone (especially Alan):
> 
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=commitdiff;h=369f16fdd423d79640c4390915e6ab71189cb497

I believe the technical description for the comment is "bullshit" 8)

Almost all MFM controllers and RLL controllers will only run at the
standard primary and secondary ATA address.

Given the intended use of the driver today I don't see a big problem in
requiring "hd=" although you have to question the point of this boot code
rewrite when it seems primarily to be removing features 

Alan
