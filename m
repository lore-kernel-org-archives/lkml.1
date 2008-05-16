Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYEPPSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYEPPSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYEPPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:18:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46739 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYEPPSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:18:37 -0400
Date: Fri, 16 May 2008 17:18:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Stas Sergeev <stsp@aknet.ru>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Non-working snd-pcsp
In-Reply-To: <s5hmymqe5a1.wl%tiwai@suse.de>
Message-ID: <alpine.LNX.1.10.0805161715470.15590@fbirervta.pbzchgretzou.qr>
References: <482737BE.20502@infracom.it> <4827415A.7060101@aknet.ru> <482756F0.8020609@infracom.it> <48275D8D.10500@aknet.ru> <4827F0A1.9090600@infracom.it> <48288ACC.1020909@aknet.ru> <48299F08.2060702@infracom.it> <4829B6A1.90707@infracom.it>
 <s5h7idycfmf.wl%tiwai@suse.de> <482A7A17.8070706@infracom.it> <s5hwslxb3t8.wl%tiwai@suse.de> <482C9A3E.3000009@infracom.it> <482C9F3E.4050104@aknet.ru> <alpine.LNX.1.10.0805161514190.15590@fbirervta.pbzchgretzou.qr> <s5hmymqe5a1.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-16 15:40, Takashi Iwai wrote:
>> 
>> If it does not even beep when issuing Ctrl-G on the shell,
>> you probably need to modprobe pcspkr, if it is not built-in.
>> (At least this is with kernels a little less
>> recent than 2.6.25. )
>
>If snd-pcsp module is built, input pcspkr module won't be built...

Previously, with Stas's standalone patch, one was able to switch
between (a) no speaker (b) beep/pcspkr (c) beep/pcspkr and
PCM/snd-pcsp, all by means of modprobe/rmmod.

Now, if pcspkr is deactivated when snd-pcsp is built... I would
not get any tone out of that piece of hardware.
Except if snd-pcsp itself contains beep code, and that would
be sort of redundant when it is already in pcspkr.
