Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYGSTJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYGSTJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 15:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYGSTJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 15:09:30 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2180 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbYGSTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 15:09:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kyuma Ohta <whatisthis.sowhat@gmail.com>
Subject: Re: [ivtv-devel] [PATCH AVAIL.]ivtv:Crash 2.6.26 with KUROTOSIKOU CX23416-STVLP
Date: Sat, 19 Jul 2008 21:08:14 +0200
User-Agent: KMail/1.9.9
Cc: ivtv-devel ML <ivtv-devel@ivtvdriver.org>,
       Video4Linux ML <video4linux-list@redhat.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <1216308014.1146.22.camel@melchior> <200807171758.19702.hverkuil@xs4all.nl> <1216336451.1146.41.camel@melchior>
In-Reply-To: <1216336451.1146.41.camel@melchior>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807192108.14376.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2008 01:13:45 Kyuma Ohta wrote:
> Dear Hans,
> Thanx for reply.

Hi Ohta,

I've decided to wait until I have access to my own card with upd64083 
and upd64031a devices. I'll be back in the Netherlands in about two 
weeks from now, and then I can pick it up and bring it back with me to 
Oslo where I can test it and fix the problem.

The backtrace doesn't really help me, I think I need to do a bit of 
debugging myself.

A bit of a shame that I didn't bring it with me a week ago. It was on my 
list of things to take with me, but my suitcase was already pretty full 
so I decided against it. Next time I'll make sure I have it :-)

For now just use your workaround. It can't do any harm, but it is not 
the right solution. That will have to wait until I can test it myself.

Regards,

	Hans

> Hans Verkuil wrote:
> > On Thursday 17 July 2008 17:20:14 Kyuma Ohta wrote:
> > > Hi,
> > > I'm testing 2.6.26/amd64 with Athlon64 x2 Box with
> > > KUROTOSIKOU CX23416-STVLP,always crash ivtv driver
> > > when loading upd64083 driver.
> > > I checked crash dump,this issue cause of loading
> > > upd64083.ko with i2c_probed_new_device().
> > > So,I fixed ivtv-i2c.c of 2.6.26 vanilla,and
> > > fixed *pretty* differnce memory allocation,structure
> > > of upd64083.c.
> > > I'm running patched 2.6.26 vanilla with below attached
> > > patches over 24hrs,and over 10hrs recording from ivtv,
> > > not happend anything;-)
> > > Please apply below to 2.6.26.x..
> > >
> > > Best regards,
> > > Ohta.
> >
> > Hi Ohta,
> >
> > Thanks for the patches. If I'm not mistaken there are several
> > variants of this card: without upd* devices, only with upd64083 and
> > with both upd devices. Which one do you have?
> >
> > Can you also show the dmesg output when ivtv loads?
> >
> > Looking at the four patches, I would say that the only relevant
> > patch is the fix-probing patch. If you try it with only that one
> > applied, does it still work correct for you? Note that this patch
> > will not work with a KUROTOSIKOU card that has no upd* devices at
> > all.
> >
> > Can you also give me the kernel backtrace when you load ivtv with
> > the vanilla 2.6.26? I do not quite understand why it should crash.
> >
> > Regards,
> >
> > 	Hans
>
> I have a ivtv card with *both* upd64083 and upd64031a.
> I don't still try testing apply only one of patch,only
> apply all of...
>
> I attach compressed logs when loading ivtv at boottime,
> parallel probing saa7134 v4l2 device,
> both applied (successed) ,not applied (failed).
>
> Best regards,
> Ohta
>
>
>
> E-Mail: whatisthis.sowhat@gmail.com (Public)
> Home Page: http://d.hatena.ne.jp/artane/
>   (Sorry,not maintaining,and written in Japanese only...)
> Twitter: Artanejp (Mainly Japanese)
> ICQ: 366538955
> KEYID: 6B79F95F
> FINGERPRINT:
> 9AB3 8569 6033 FDBE 352B  CB6D DBFA B9E2 6B79 F95F


