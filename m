Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYHJQUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYHJQUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 12:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYHJQUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 12:20:30 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:53783 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYHJQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 12:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zzk2HC+AKPR4c4sfE7TOEIvUSpLQrcZc53Qnhx+sjygNz0p6kvj/wnLiAmuwJhhcty
         ZHcOS9kJOUUyHoV/rBoHpTECqmCX6LPQfLJKzkowjco20e8ufaxGsQmPP4W3r4jAZi1c
         URlwXAX7OXKWkdNNKi074UmMDtHIiodvWfCmk=
Subject: Re: [PATCH AVAIL.]ivtv:Crash 2.6.26 with KUROTOSIKOU CX23416-STVLP
From: Kyuma Ohta <whatisthis.sowhat@gmail.com>
To: JeanDelvare <khali@linux-fr.org>, HansVerkuil <hverkuil@xs4all.nl>,
       Video4Linux ML <video4linux-list@redhat.com>,
       ivtv-devel ML <ivtv-devel@ivtvdriver.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: whatisthis.sowhat@gmail.com
In-Reply-To: <20080807150738.5b1dde60@hyperion.delvare>
References: <1216308014.1146.22.camel@melchior>
	 <200807171758.19702.hverkuil@xs4all.nl> <1216336451.1146.41.camel@melchior>
	 <200808032312.25222.hverkuil@xs4all.nl>
	 <20080807150738.5b1dde60@hyperion.delvare>
Content-Type: text/plain; charset=ISO-2022-JP
Date: Sun, 10 Aug 2008 16:40:59 +0900
Message-Id: <1218354059.5457.9.camel@melchior.hokkemirin.ddo.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hans,and Jean;
 I was applied Hans's patch to 2.6.26.1 vanilla at
morning of 08/06 (JST),and running to now,problem
cause from IIC issue was not happend.
 Thanx for you (^^)

Ohta
---
E-Mail: whatisthis.sowhat@gmail.com (Public)
Home Page: http://d.hatena.ne.jp/artane/ 
&nbsp; (Sorry,not maintaining,and written in Japanese only...)
Twitter: Artanejp (Mainly Japanese)
KEYID: 6B79F95F
FINGERPRINT:
9AB3 8569 6033 FDBE 352B&nbsp; CB6D DBFA B9E2 6B79 F95F
---

2008-08-07 (Thu) の 15:07 +0200, Jean Delvare wrote:
> Hi Hans,
> 
> On Sun, 3 Aug 2008 23:12:25 +0200, Hans Verkuil wrote:
> > Hi Ohta,
> > 
> > Well, I picked up my card this weekend and tested it. It turns out to be 
> > an i2c-core.c bug: chips with i2c addresses in the 0x5x range are 
> > probed differently than other chips and the probe command contains an 
> > error. The upd64083 has an address in that range and so was hit by this 
> > bug. The attached patch for linux/drivers/i2c/i2c-core.c will fix it.
> > 
> > As you can see, this mail also goes to Jean Delvare so that he can move 
> > this upstream (should also go to the 2.6.26-stable series, Jean!).
> > 
> > For the ivtv driver this bug will only hit cards where ivtv has to probe 
> > for an upd64083.
> > 
> > SoB for this patch:
> > 
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> > 
> > I've verified that this is only an issue with kernels 2.6.26 and up. 
> > Older kernels are not affected unless the ivtv driver from the v4l-dvb 
> > repository is used. To be more precise: this bug has been in i2c-core.c 
> > since 2.6.22, but the ivtv driver in 2.6.26 was the first driver that 
> > used i2c_new_probed_device() with an i2c address in a range that caused 
> > the broken probe to be used.
> 
> Good catch, thanks for the patch. I'll push it to Linus by the end of
> the week.
> 

