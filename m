Return-Path: <linux-kernel-owner+w=401wt.eu-S933024AbXBLGN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024AbXBLGN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXBLGN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:13:28 -0500
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:41887 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbXBLGN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:13:27 -0500
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: CPU load
Date: Mon, 12 Feb 2007 17:12:50 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <loom.20070212T063225-663@post.gmane.org> <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com> <Pine.LNX.4.64.0702120849310.903@home.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0702120849310.903@home.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702121712.50168.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 February 2007 16:54, malc wrote:
> On Mon, 12 Feb 2007, Con Kolivas wrote:
> > On 12/02/07, Vassili Karpov <av1474@comtv.ru> wrote:
>
> [..snip..]
>
> > The kernel looks at what is using cpu _only_ during the timer
> > interrupt. Which means if your HZ is 1000 it looks at what is running
> > at precisely the moment those 1000 timer ticks occur. It is
> > theoretically possible using this measurement system to use >99% cpu
> > and record 0 usage if you time your cpu usage properly. It gets even
> > more inaccurate at lower HZ values for the same reason.
>
> Thank you very much. This somewhat contradicts what i saw (and outlined
> in usnet article), namely the mplayer+/dev/rtc case. Unless ofcourse
> /dev/rtc interrupt is considered to be the same as the interrupt from
> PIT (on X86 that is)
>
> P.S. Perhaps it worth documenting this in the documentation? I caused
>       me, and perhaps quite a few other people, a great deal of pain and
>       frustration.

Lots of confusion comes from this, and often people think their pc suddenly 
uses a lot less cpu when they change from 1000HZ to 100HZ and use this as an 
argument/reason for changing to 100HZ when in fact the massive _reported_ 
difference is simply worse accounting. Of course there is more overhead going 
from 100 to 1000 but it doesn't suddenly make your apps use 10 times more 
cpu.

-- 
-ck
