Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbXBLGyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbXBLGyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 01:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXBLGyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 01:54:06 -0500
Received: from comtv.ru ([217.10.32.17]:47808 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050AbXBLGyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 01:54:05 -0500
X-Greylist: delayed 3597 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 01:54:04 EST
X-UCL: actv
Date: Mon, 12 Feb 2007 08:54:25 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@home.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: CPU load
In-Reply-To: <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702120849310.903@home.oyster.ru>
References: <loom.20070212T063225-663@post.gmane.org>
 <8cd998d50702112144y38958d27saec4196f6f5d5236@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, Con Kolivas wrote:

> On 12/02/07, Vassili Karpov <av1474@comtv.ru> wrote:

[..snip..]

> The kernel looks at what is using cpu _only_ during the timer
> interrupt. Which means if your HZ is 1000 it looks at what is running
> at precisely the moment those 1000 timer ticks occur. It is
> theoretically possible using this measurement system to use >99% cpu
> and record 0 usage if you time your cpu usage properly. It gets even
> more inaccurate at lower HZ values for the same reason.

Thank you very much. This somewhat contradicts what i saw (and outlined
in usnet article), namely the mplayer+/dev/rtc case. Unless ofcourse
/dev/rtc interrupt is considered to be the same as the interrupt from
PIT (on X86 that is)

P.S. Perhaps it worth documenting this in the documentation? I caused
      me, and perhaps quite a few other people, a great deal of pain and
      frustration.

-- 
vale
