Return-Path: <linux-kernel-owner+w=401wt.eu-S1763819AbXHYNhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763819AbXHYNhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 09:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXHYNhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 09:37:05 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:50896 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXHYNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 09:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ncqj4/hXCwiEA21XMK7U1pRPdXw/oGTkKb2KdzNhsTqW4rHLZI/VGhcdFW+n5yHDZYzdPKHieY6+Cn3BbcVDeKXYQCo/8RBPm9sojlOzvwaOkWe+t6nRS53CSrTcULvP48akGWDUw5SAbqEEkSbwOPSOXdkB0YM2xjchCFY1Vgs=
Message-ID: <6d4bc9fc0708250637g10c75f44x20ae1533874c986a@mail.gmail.com>
Date: Sat, 25 Aug 2007 15:37:00 +0200
From: "Maarten Maathuis" <madman2003@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [sata_nv] timeout waiting for ADMA IDLE, stat=0x440
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46CF68C4.9040506@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.JryGluomV43EviuSMJKX+JI+tvU@ifi.uio.no>
	 <46CF68C4.9040506@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A broken cable seems like a realistic possibility, so i swapped it for
another cable. I will try if that solves the problem.

Maarten.

On 8/25/07, Robert Hancock <hancockr@shaw.ca> wrote:
> Maarten Maathuis wrote:
> > I have this problem several times, always with the same harddrive, a
> > samsung sp2004c. My samsung hd161hj and hd321kj don't seem to suffer
> > from this problem. I do not know when exactly it happened for the
> > first, but it has happened twice on a 2.6.22 kernel.
> >
> > Is there anything that can be done about this (besides disabling adma
> > for all drives), or any information i can provide to help?
> >
> > Please CC me, as i am not a member of this mailinglist.
> >
> > Sincerely,
> >
> > Maarten Maathuis.
> >
> > dmesg snippet:
> >
> > ata4: timeout waiting for ADMA IDLE, stat=0x440
> > ata4.00: qc timeout (cmd 0x2f)
> > ata4: failed to read log page 10h (errno=-5)
> > ata4.00: exception Emask 0x1 SAct 0x1 SErr 0x380000 action 0x2 frozen
> > ata4.00: (CPB resp_flags 0x11: CMD error)
> > ata4.00: cmd 60/80:00:89:b0:30/00:00:02:00:00/40 tag 0 cdb 0x0 data 65536 in
> >          res 51/84:00:02:00:00/84:00:02:00:00/40 Emask 0x10 (ATA bus error)
>
> Sounds like the drive has gotten into a really hosed state after this
> point. The SError register is showing a CRC error, disparity error, and
> 10b to 8b decode error, which indicates that there are some major SATA
> communication problems happening.
>
> It could be a hardware problem (bad drive, bad SATA cable, insufficient
> power, etc.) or maybe this is another drive with broken NCQ..
>
> --
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>
>
