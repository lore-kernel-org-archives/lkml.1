Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbXJKLEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbXJKLEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXJKLE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:04:26 -0400
Received: from mail.station1.mxsweep.com ([212.147.136.149]:2114 "EHLO
	smtp2.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbXJKLEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:04:25 -0400
X-Greylist: delayed 1282 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 07:04:25 EDT
Message-ID: <470DFE18.7010001@draigBrady.com>
Date: Thu, 11 Oct 2007 11:42:32 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070919)
MIME-Version: 1.0
To: Aidan Thornton <makosoft@googlemail.com>
CC: Markus Rechberger <mrechberger@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
References: <1192053794.15601.47.camel@gaivota>	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>	 <d9def9db0710101624t5e0a3523p12c367dc1d414349@mail.gmail.com>	 <470D61CF.3070307@redhat.com>	 <d9def9db0710102159q2e5f9dadr341b409285f262e0@mail.gmail.com> <c8b4dbe10710110250w10ddfc0du6ae4b6bb95cb2d2f@mail.gmail.com>
In-Reply-To: <c8b4dbe10710110250w10ddfc0du6ae4b6bb95cb2d2f@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Oct 2007 10:43:57.0888 (UTC) FILETIME=[A0911400:01C80BF3]
X-CTCH-RefID: str=0001.0A010206.470DFE2E.0041:SCCEO7923,ss=1,fgs=0
X-MXUniqueID: d877358c-a6b4-4bdc-9ca0-5a5adfc77ec4
X-MXSweep-Threat: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aidan Thornton wrote:
> I looked at this recently, and I'm not sure the core em28xx code was
> really that different (at least, pre-userspace). Most of the core
> changes seemed to be related to Markus' driver having (semi-working)
> VBI support. I haven't tried this recently; I disabled it a while back
> because it had a bug that caused a kernel panic half the time when
> attempting to record something with MythTV.
> 
> The in-kernel driver looks mostly sound, though I can't test it
> myself. (One other interesting thing that was added in Markus' driver
> is various v4l1 ioctls, which may be useful to some people.)

Yes, for example VLC doesn't support v4l2 yet.
Here is a patch I back ported to 2.6.17 last year.
http://www.pixelbeat.org/patches/linux-2.6.17-em28xx-v4l1.diff
I didn't try to get it merged as I thought Markus would do it,
but looks like that's unlikely now.

Also here is a patch to allow shared access to the video device
(so you can have a separate tuner program to VLC for example):
http://www.pixelbeat.org/patches/linux-2.6.17-em28xx-shared.diff

> Incidentally, I notice you appear to be developing userspace drivers
> for the tvp5150 and zl10353. Is that really necessary?

It is necessary if Markus wants to stop people merging code back from
his in-kernel driver fork. Call me a cynic, but I'm confused about Markus'
motives in all this.

Markus, please do the right thing and just merge your code!
(and please don't reply this giving reasons you won't/can't do this).

Pádraig.
