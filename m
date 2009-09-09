Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZIIWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZIIWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZIIWZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:25:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29339 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZIIWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:25:55 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5736"; a="23364692"
From: "Huntsman, Bryan" <bryanh@quicinc.com>
To: Brian Swetland <swetland@google.com>, Daniel Walker <dwalker@fifo99.com>
CC: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Wed, 9 Sep 2009 15:25:56 -0700
Subject: RE: Staging tree status for the .32 kernel merge
Thread-Topic: Staging tree status for the .32 kernel merge
Thread-Index: AcoxmAYAv5ZX9RO2TF+ZEykoZpngkAAATorw
Message-ID: <ED35FE86DA24A84894C93FF3B8C47D8C05B2F177BC@NASANEXMB11.na.qualcomm.com>
References: <20090903041429.GA29875@kroah.com>
 <20090906052819.GE1324@ucw.cz>	 <1252338939.2139.21.camel@desktop>
 <20090909095702.GB28615@elf.ucw.cz>	 <1252505941.14793.97.camel@desktop>
 <a55d774e0909091453l5f658212wa3fe3df685a353c@mail.gmail.com>
In-Reply-To: <a55d774e0909091453l5f658212wa3fe3df685a353c@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n89NI116005419

> On Wed, Sep 9, 2009 at 7:19 AM, Daniel Walker<dwalker@fifo99.com> wrote:
> > On Wed, 2009-09-09 at 11:57 +0200, Pavel Machek wrote:
> >> Hi!
> >> > > > Â  Â  Â  Â  Â  Note, Pavel has been adding some of the Dream hardware
> >> > > > Â  Â  Â  Â  Â  drivers, which are separate from the core Android drivers.
> Â I
> >> > > > Â  Â  Â  Â  Â  have no objection to those, but they should work to get
> merged
> >> > > > Â  Â  Â  Â  Â  to their "correct" places in the tree in another release
> or
> >> > > > Â  Â  Â  Â  Â  so.
> >> > >
> >> > > Well, some of those drivers should be moderately easy (touchscreen),
> >> > > but some (camera) will take longer than that. For example camera --
> >> > > contains _lots_ of code, and uses obsolete v4l api.
> >> > >
> >> > > Plus, I really need to get recent kernel to boot and then get arch/arm
> >> > > pieces merged....
> >> >
> >> > I've got a tree with a lot of the arch/arm/msm pieces isolated, doesn't
> >> > boot yet .. I had to drop certain parts like the key pad support since
> >> > it had a big generic change attached to it .. It's all part of a git
> >> > tree which I can expose if you want to look at it.
> >>
> >> Yes, minimal, but booting version would be very welcome. I tried to
> >> produce exactly that few times, but did not succeed (yet).
> >
> > Last night I discovered maybe a better tree to use ..
> >
> > https://www.codeaurora.org/gitweb/quic/kernel/?p=bryanh/linux-
> 2.6.git;a=summary
> >
> > It's based off a newer kernel 2.6.31-rc6 . I have a feeling it's minus a
> > lot of the google stuff.
> 
> That would be somewhat surprising, since the qct/quicinc folks support
> the full android stack on top of their kernels (though we're not
> entirely converged at this point).
> 
> Not sure if their tree has full support for devices like
> dream/sapphire/etc -- I believe they primarily verify on their SURF
> platform.  Added Bryan to the CC so he can comment.
> 
> Brian

Brian, the tree you reference is not for Android.  It's just a minimal tree to boot our internal SURF platform on .31.  It may have some android bits in it but they are not used.  We only validated console and the sd bus driver.  Our latest released Android tree is https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29b.  It's based on your android-msm-2.6.29 branch from back in May and has whatever dream/sapphire support you had at that time.

- Bryan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
