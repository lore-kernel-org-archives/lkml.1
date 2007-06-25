Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXFYOCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXFYOCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 10:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbXFYOCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 10:02:13 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:1171 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbXFYOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 10:02:13 -0400
Date: Mon, 25 Jun 2007 16:02:06 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <467FC143.4040906@mandic.com.br>
Message-ID: <Pine.BSO.4.63.0706251555001.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
 <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
 <467FC143.4040906@mandic.com.br>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-117471810-1182780126=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-117471810-1182780126=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jun 2007, Renato S. Yamane wrote:

> Tomasz K³oczko wrote:
>> ALSA still does not provides good soud devices virtualization for more then 
>> one application. Each day I'm using bludy words when I'm try to use skype 
>> which oppens /dev/mixer after run galeon with flash plugin which opens 
>> /dev/snd/pcm* or when I start GNOME session with soud enabled (handled by 
>> esd whuich uses ALSA).
>
>
> Install alsa-oss fix this problem?
> <http://www.skype.com/help/guides/soundsetup_linux.html>

No. Read above again and you will see I'm taking about using OSS emulation 
on top ALSA. It does not work with above scenario.

# lsmod | grep snd
snd_emu10k1_synth      11073  0
snd_emux_synth         35681  1 snd_emu10k1_synth
snd_seq_virmidi        11336  1 snd_emux_synth
snd_seq_midi_emul      10049  1 snd_emux_synth
snd_emu10k1           131121  2 snd_emu10k1_synth
snd_intel8x0           36837  5
snd_seq_dummy           7877  0
snd_ac97_codec         98941  2 snd_emu10k1,snd_intel8x0
snd_seq_oss            34257  0
snd_mpu401             12521  0
snd_mpu401_uart        12633  1 snd_mpu401
snd_seq_midi_event     11337  2 snd_seq_virmidi,snd_seq_oss
snd_rawmidi            27233  3 snd_seq_virmidi,snd_emu10k1,snd_mpu401_uart
snd_seq                52377  8 snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
ac97_bus                6721  1 snd_ac97_codec
snd_seq_device         12245  7 snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq
snd_pcm_oss            44129  0
snd_mixer_oss          19785  4 snd_pcm_oss
snd_util_mem            8904  2 snd_emux_synth,snd_emu10k1
snd_pcm                76653  5 snd_emu10k1,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_hwdep              13133  2 snd_emux_synth,snd_emu10k1
snd_timer              25565  3 snd_emu10k1,snd_seq,snd_pcm
snd                    55301  21 snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_intel8x0,snd_ac97_codec,snd_seq_oss,snd_mpu401,snd_mpu401_uart,snd_rawmidi,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_hwdep,snd_timer
soundcore              11809  4 snd
snd_page_alloc         13897  3 snd_emu10k1,snd_intel8x0,snd_pcm

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-117471810-1182780126=:25800--
