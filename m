Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYGUAj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYGUAj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYGUAjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:39:16 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:52511 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYGUAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VT2PaINxeXfOJTQSrVkLtEsNtpPEYUpg55j+sI0Fe/ovY9lgioj7PI9+scblSwG2+I
         Y0o1gC8nuKn2rVm+RiGArvABBu4qxjfwsPibVGdLybjOwghapP8oPEMmP1NAMcCI+HQT
         2Hyt0/ZZxhkhMPDoLac5qjfVl9y8z/ekn7wao=
Message-ID: <4883DA8C.5030306@gmail.com>
Date: Mon, 21 Jul 2008 09:38:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com>	<20080719004736.626ef169@mjolnir.drzeus.cx>	<48813C5F.70007@gmail.com>	<20080719033050.552f9b49@mjolnir.drzeus.cx>	<48814D81.8060001@gmail.com>	<20080719140717.7b296eae@mjolnir.drzeus.cx>	<4881F437.7000503@gmail.com> <20080721004033.1fc66aa3@mjolnir.drzeus.cx>
In-Reply-To: <20080721004033.1fc66aa3@mjolnir.drzeus.cx>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pierre.

Pierre Ossman wrote:
> I've converted my code to use your implementation instead, and it seems
> to be working perfectly.

Cool.

> How comfortable to you feel about your patch? :)

I think it should be okay (well, of course :-) and tested a few corner
cases by modifying the copy function.

> This fixes a big problem in the sdhci driver where falling back on PIO
> (because of hw DMA bugs) would create lots of potential issues as the
> driver couldn't access highmem pages. I'd like to get this fix in for
> 2.6.27, which means that your patch also needs to go in now.

I think it needs an ACK from Jens.  Jens?

-- 
tejun
