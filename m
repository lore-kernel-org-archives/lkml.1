Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0CJMzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 07:55:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:55496 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab0CJMzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 07:55:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,614,1262592000"; 
   d="scan'208";a="779566708"
Date: Wed, 10 Mar 2010 20:54:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: VDR User <user.vdr@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Wei Ni <wni@nvidia.com>,
       Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>,
       Jaroslav Kysela <jkysela@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Pavel Hofman <pavel.hofman@insite.cz>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Message-ID: <20100310125456.GA18509@localhost>
References: <s5htyswpb18.wl%tiwai@suse.de> <6B4D417B830BC44B8026029FD256F7F1C16B1AD557@HKMAIL01.nvidia.com> <s5hvddcnlr6.wl%tiwai@suse.de> <6B4D417B830BC44B8026029FD256F7F1C16B1AD558@HKMAIL01.nvidia.com> <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com> <6B4D417B830BC44B8026029FD256F7F1C16B1AD562@HKMAIL01.nvidia.com> <20100308044614.GA29026@localhost> <a3ef07921003092142g23b93903v2b4af9c6b691bea0@mail.gmail.com> <alpine.LNX.2.00.1003100856420.4672@eeebox2.perex-int.cz> <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ef07921003100005k6c7da149k99069cc13b3c8183@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Could you do strace for ALSA ioctls? At least having the error code might
> > help to identify this issue.
> 
> I don't know how but I'm willing to try if you want to tell me how to
> do it.  Please keep in mind, I'm just an end-user -- not a developer
> or even c coder.  The most I've done is run xine in gdb to help supply
> bug info to those devs.

strace -o alsa-strace  speaker-test -Dhw:0,3 -t wav -c2 -l1                

Or 

strace -o alsa-strace  mplayer -ao alsa:device=hw=0.3 XXXXXXXX.mp3


Do you see error messages when playing via other audio devices, eg.

        mplayer -ao alsa:device=hw=0.0 XXXXXXXX.mp3

?

Thanks,
Fengguang
