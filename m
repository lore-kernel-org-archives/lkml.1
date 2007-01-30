Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXA3UgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXA3UgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXA3UgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:36:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:27617 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbXA3UgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:36:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KplEvXQP+IPYQ74Nf1CvR+A4TTEDeHUCTvB+R8XrLsYVnBh+MqQUTZRYWJFA1vpPjm3nt4niDq7rkhr2/YliAGmxqbI1lafEAW4JoiG7DD6E0zTxLXPvnOAQn95WwG4FY66ub/IRxlZKRclOsIZo+VbkR3ckc4bajuxlaD0r7Gk=
Date: Tue, 30 Jan 2007 21:36:01 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Message-ID: <20070130203601.GB15067@dreamland.darkstar.lan>
References: <20070130195319.GA10994@dreamland.darkstar.lan> <Pine.LNX.4.61.0701302100370.13737@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0701302100370.13737@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Tue, Jan 30, 2007 at 09:02:20PM +0100, Jan Engelhardt ha scritto: 
> 
> On Jan 30 2007 20:53, Luca Tettamanti wrote:
> >Hi,
> >pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> 
> Did it work previously?

Yup, It used to work but since I rarely use it I don't remember which
kernel version worked for me.

> 
> >is written to the device is lost after umount.
> >I rarely use pktcdvd but at some point it used to work on my system.
> >
> >This is what I'm doing:
> >
> >root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> >scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
> 
> In case you are using ide-scsi: try without.

It's libata jmicron driver. Shall I try the "old" PATA driver on the
next reboot?

Luca
-- 
"Chi parla in tono cortese, ma continua a prepararsi, potra` andare avanti;
 chi parla in tono bellicoso e avanza rapidamente dovra` ritirarsi" 
Sun Tzu -- L'arte della guerra
