Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0CJRih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:38:37 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:40643 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab0CJRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:38:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mIXjGuPL6qksLPdOKiSjTaQ2uZ/f4zATne44gJ1djPbfblM7+HS5ePpvRAkuMg4uqn
         cVytkRKRZGM6akEjBCPTyejBrDJKkM+oX1Xj5dxmxAlHnzs21Wwe9mzN98PDMRo59sEp
         PlYgxhJfJR9xHVBM5741+w1cpc3iUkxqeKKwY=
MIME-Version: 1.0
In-Reply-To: <20100310125456.GA18509@localhost>
References: <s5htyswpb18.wl%tiwai@suse.de> <s5hvddcnlr6.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD558@HKMAIL01.nvidia.com>
	 <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD562@HKMAIL01.nvidia.com>
	 <20100308044614.GA29026@localhost>
	 <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com>
	 <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz>
	 <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com>
	 <20100310125456.GA18509@localhost>
Date: Wed, 10 Mar 2010 09:38:33 -0800
Message-ID: <a3ef07921003100938o4d94161fw559bc9b563ce55b@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
From: VDR User <user.vdr@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I'm not sure what I'm supposed to be looking for so I'll paste
some lines that include everything I see:

pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
[pid 22651] ioctl(21, 0x806c4120, 0xb439d230) = 0
[pid 22651] ioctl(21, 0x400c4150, 0xb439d1a4) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22652] ioctl(18, 0xc0104652 <unfinished ...>
[pid 22649] ioctl(10, 0xc0104652 <unfinished ...>
[pid 22652] <... ioctl resumed> , 0xb37b2590) = 0
[pid 22649] <... ioctl resumed> , 0xb547df00) = 0
[pid 22651] ioctl(21, 0x80044121, 0xb439d2cc) = -1 EPIPE (Broken pipe)
pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
[pid 22651] ioctl(21, 0x806c4120, 0xb439d230) = 0
[pid 22651] ioctl(21, 0x400c4150, 0xb439d1a4) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22649] ioctl(4, 0xc020462a, 0xb547e030) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22651] ioctl(21, 0x80044121, 0xb439d2cc) = -1 EPIPE (Broken pipe)
pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
[pid 22651] ioctl(21, 0x806c4120, 0xb439d230) = 0
[pid 22651] ioctl(21, 0x400c4150, 0xb439d1a4) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22651] ioctl(21, 0x80044121, 0xb439d2cc) = -1 EPIPE (Broken pipe)
pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
[pid 22651] ioctl(21, 0x806c4120, 0xb439d230) = 0
[pid 22651] ioctl(21, 0x400c4150, 0xb439d1a4) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22649] ioctl(10, 0xc0104652 <unfinished ...>
[pid 22652] ioctl(18, 0xc0104652 <unfinished ...>
[pid 22649] <... ioctl resumed> , 0xb547df00) = 0
[pid 22652] <... ioctl resumed> , 0xb37b2590) = 0
[pid 22652] ioctl(18, 0xc0104652, 0xb37b2590) = 0
[pid 22649] ioctl(4, 0xc020462a, 0xb547e030) = 0
[pid 22651] ioctl(21, 0x80044121, 0xb439d2cc) = -1 EPIPE (Broken pipe)

This is with starting xine with:
strace -f -e trace=open,ioctl xine -A alsa -V vdpau --post vdr_video
--post vdr_audio vdr://tmp/vdr-xine/stream#demux:mpeg_pes --verbose=2
--fullscreen --no-gui --no-mouse --deinterlace --no-logo --no-splash &

Hopefully this helps!..(?)

Best regards,
Derek
