Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbXELSkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbXELSkg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXELSk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:40:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:2818 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbXELSk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YV5ASdeesQWpwXWgl7lGLB9h9+jPhA5UeeGAazkVAgr41wx96zY6R69YZc/M/1+b8Z5DS1YhBAQ2LAclMuC41Y3yoXEItzeIVAMy24tR9JTX6bI/BSGMHuJpSVY9s8qpc9GgplIoLCtNev6V5L242LnLssoNPwkw0QIqwawb79A=
Message-ID: <6bffcb0e0705121140i2f96f94eq4f48fd734e72b6b6@mail.gmail.com>
Date: Sat, 12 May 2007 20:40:28 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrej Hocevar" <and.hocevar@gmail.com>
Subject: Re: PROBLEM: possible kernel bug
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070512181019.GA5868@stoa>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070512181019.GA5868@stoa>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrej,

On 12/05/07, Andrej Hocevar <and.hocevar@gmail.com> wrote:
> as i've lately been forced to see the following message, i decided to
> report this. i hope it's the right place to do it.
>
> kernel: ------------[ cut here ]------------
> kernel: Kernel BUG at [verbose debug info unavailable]
> [...]
>
> here is the latest bug message:
>
> ===================
>
> May 12 19:52:52 stoa kernel: ------------[ cut here ]------------
> May 12 19:52:55 stoa kernel: Kernel BUG at [verbose debug info
> unavailable]
> May 12 19:52:55 stoa kernel: invalid opcode: 0000 [#1]
> May 12 19:52:55 stoa kernel: PREEMPT
> May 12 19:52:55 stoa kernel: Modules linked in: psmouse nls_cp437 nfs
> lockd sunrpc loop ppdev lp af_packet sr_mod sbp2 scsi_mod snd_intel8x0
> snd_ac97_codec snd_ac97_bus snd_pcm_oss ieee80211 snd_mixer_oss
> ieee80211_crypt irda parport_pc parport snd_pcm snd_timer crc_ccitt
> pcspkr rtc snd_page_alloc eth1394 e100 mii ohci1394 ieee1394 ehci_hcd
> uhci_hcd usbcore unix
> May 12 19:52:55 stoa kernel: CPU:    0
> May 12 19:52:55 stoa kernel: EIP:    0060:[<c01544a9>]    Tainted: GF
> VLI

You are using tainted kernel.

"  2: 'F' if any module was force loaded by "insmod -f", ' ' if all
     modules were loaded normally."
Documentation/oops-tracing.txt

Please try to reproduce this bug on non-tainted kernel.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
