Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYH2I3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYH2I3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYH2I3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:29:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:47481 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYH2I3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:29:42 -0400
Message-ID: <48B7B327.3060306@kernel.org>
Date: Fri, 29 Aug 2008 10:28:23 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <48B751DA.5090906@kernel.org> <20080829065026.GC16462@cs181140183.pp.htv.fi> <48B7A48B.8020405@kernel.org> <20080829082129.GF16462@cs181140183.pp.htv.fi>
In-Reply-To: <20080829082129.GF16462@cs181140183.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 08:29:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Adrian Bunk wrote:
>> Yeah, that's why I agree it's a bit too late but still better late than
>> never.  There are just some programs, be it commercial or ancient, which
>> don't work quite as well as it could.  Requiring update to ALSA took
>> painfully long years and we're still not in the clear yet.  Now should
>> we ask people to update to PA?
>> ...
> 
> Doesn't PA already emulate ALSA?

There's an ALSA plugin which connects to PA.  It works pretty well most
of the time although there are some odd ones which break.  Skype didn't
work too well a few months ago.  Dunno how it works these days tho and
it's likely that the next iteration of popular audio apps will do PA
directly.

>> ossp is simply a better way to support /dev/dsp on modern systems and
>> bulk of it lives in userland (and I hope this can be the case for future
>> deprecations too).  If for nothing else, it'll enable us to do away with
>> three different emulations at the very least.  I mean we can't of course
>> do away with padsp and then some still only work with aoss and then we
>> need in-kernel ALSA OSS emulation as the final fallback when both fail.
>>  It's a big mess and ossp can basically OSS emulation as good as
>> in-kernel ALSA OSS w/ muxing.
> 
> The in-kernel OSS emulation also support OSS MIDI.

Yeah, and adding midi support to ossp won't add one line of code to the
kernel.  :-)

Thanks.

-- 
tejun
