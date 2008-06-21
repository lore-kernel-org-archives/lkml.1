Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYFUSel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYFUSel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYFUSeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:34:31 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:41040 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYFUSeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:34:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: hdparm -M acoustic management for sata disks?
Date: Sat, 21 Jun 2008 20:34:22 +0200
User-Agent: KMail/1.9.9
Cc: Mark Lord <lkml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>
References: <1214043295.17302.16.camel@localhost> <485D098E.3080109@rtr.ca> <1214066456.18959.6.camel@localhost>
In-Reply-To: <1214066456.18959.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212034.24059.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008 18:40:56 Soeren Sonnenburg wrote:
> On Sat, 2008-06-21 at 10:00 -0400, Mark Lord wrote:
> > Soeren Sonnenburg wrote:
> > > Dear all,
> > >
> > > why is acoustic management via hdparm not supported for sata disks?
> > >
> > > # hdparm -M /dev/sda
> > >
> > > /dev/sda:
> > >  acoustic      = not supported
> >
> > ..
> >
> > No, that means that your *drive* doesn't support it.
> > Check for yourself, with "hdparm -I /dev/sda | grep Acoustic".
>
> Just to be sure, did you mean grep acoustic (lowercase)? Because it is
> listed there under Capabilities:
> Recommended acoustic management value: 128, current value: 0
>
> I've tried with the 5 sata drives I could get my hands on, they all list
> some recommended acoustic management value but all fail the same way
>
> # hdparm -M 128 /dev/sda
>
> /dev/sda:
>  setting acoustic management to 128
>  HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error
>  acoustic      = not supported
>

Aren't they Seagate drives? They're known not to support acoustic management.

> > ..
> >
> > > Is there any patch flying around that already enables this or even any
> > > ETA in the current mainstream?
> >
> > ..
> >
> > No patch required -- hdparm (newer versions) already do this correctly.
>
> I have hdparm v8.9 here, is that new enough?
>
> Thanks for you help,
> Soeren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
