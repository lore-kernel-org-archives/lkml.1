Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0CKSdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:33:04 -0500
Received: from mail1.perex.cz ([212.20.107.53]:34419 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab0CKScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:32:18 -0500
Date: Thu, 11 Mar 2010 19:32:14 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
To: VDR User <user.vdr@gmail.com>
cc: Wu Fengguang <fengguang.wu@intel.com>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
In-Reply-To: <a3ef07921003111015x2386cc80x73a2a4bd679b1fe1@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1003111927570.4672@eeebox2.perex-int.cz>
References: <s5htyswpb18.wl%tiwai@suse.de>  <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com>  <6B4D417B830BC44B8026029FD256F7F1C16B1AD562@HKMAIL01.nvidia.com>  <20100308044614.GA29026@localhost>  <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com>
  <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz>  <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com>  <20100310125456.GA18509@localhost>  <a3ef07921003100938o4d94161fw559bc9b563ce55b@mail.gmail.com>  <alpine.LNX.2.00.1003110824390.4672@eeebox2.perex-int.cz>
 <a3ef07921003111015x2386cc80x73a2a4bd679b1fe1@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, VDR User wrote:

> On Wed, Mar 10, 2010 at 11:30 PM, Jaroslav Kysela <perex@perex.cz> wrote:
>> On Wed, 10 Mar 2010, VDR User wrote:
>>
>>> [pid 22651] ioctl(21, 0x80044121, 0xb439d2cc) = -1 EPIPE (Broken pipe)
>>> pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.
>>
>> -EPIPE means underrun condition.
>>
>> Try 'echo 101 > /proc/asound/card0/pcm0p/xrun_debug' and send dmesg output
>> to check if the ring buffer pointer in the hda-intel driver does not return
>> wrong values. Replace card0 and pcm0p with right identifiers (look to 'aplay
>> -l' for right numbers).
>>
>> More info: http://www.alsa-project.org/main/index.php/XRUN_Debug
>
> Hi, thanks for your further reply.  However, I don't see
> "CONFIG_SND_PCM_XRUN_DEBUG" anywhere in the kernel config (both in
> menuconfig or .config).

All these parameters should be set: CONFIG_SND_PCM_XRUN_DEBUG, 
CONFIG_SND_VERBOSE_PROCFS, CONFIG_SND_DEBUG . I updated wiki.

 					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

