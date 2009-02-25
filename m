Return-Path: <linux-kernel-owner+w=401wt.eu-S1762296AbZBYXlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762296AbZBYXlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZBYXlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:41:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:34264 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbZBYXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=g4zoqPyfDL/qZml6pSueSZCd50PpcIfYUQoR1LwGbq1D/vWfoVp4bZDoAzWhpTthAs
         VD17EpQQ15Wmbn2LYo7TVI3pIP6iqKP7093QdfJHlCFtGlmCOUMCkWXmhqJZWj6nbbFw
         1y9T7JYyTLmDCVxCgPOPIeoA2lH8yA87v/0lM=
Message-ID: <49A5D70D.1090808@gmail.com>
Date: Wed, 25 Feb 2009 18:41:01 -0500
From: jacques <ocean4200@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: no sound with DIGITAL INPUT
References: <49A175E4.6070608@gmail.com>	<s5hfxi484d9.wl%tiwai@suse.de>	<49A49537.8050002@gmail.com> <s5htz6jja1l.wl%tiwai@suse.de>
In-Reply-To: <s5htz6jja1l.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've compiled again with verbose enabled then selected auto for the 
model (still no sound from digital input). I played with arecord a 
little bit before copying the outputs from dmesg. Sometimes, when 
recording, it shows buffer underrun. I can see some error in the log as 
well as strange detection like "MSI" config but the motherboard is a 
Giga-Byte. It detects the right model (6-stack-dig). We can see some 
"disabled"  messages. Also, it detects the digital input for the PCBeep 
(input: HDA Digital PCBeep)??? Strange... Anyway, here is the dmesg:

[  111.471389] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  114.407938] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[  114.407960] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  114.407963] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:2222: 
chipset global capabilities = 0x4401
[  114.481257] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:786: 
codec_mask = 0xc
[  114.481377] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1214: 
hda_intel: codec #2 probed OK
[  114.481417] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1214: 
hda_intel: codec #3 probed OK
[  114.483997] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:2937: 
hda_codec: model '6stack-dig' is selected for config 1458:a002 (MSI)
[  114.484051] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input5
[  114.632715] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Headphone Playback Volume, skipped
[  114.632722] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Speaker Playback Volume, skipped
[  114.632725] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Mono Playback Volume, skipped
[  114.632728] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Line-Out Playback Volume, skipped
[  114.632730] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave PCM Playback Volume, skipped
[  114.632737] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Speaker Playback Switch, skipped
[  114.632740] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Mono Playback Switch, skipped
[  117.391386] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  142.179407] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[  142.179432] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  142.179435] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:2222: 
chipset global capabilities = 0x4401
[  142.250009] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:786: 
codec_mask = 0xc
[  142.250079] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1214: 
hda_intel: codec #2 probed OK
[  142.250123] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1214: 
hda_intel: codec #3 probed OK
[  142.252519] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:2912: 
hda_codec: model 'auto' is selected
[  142.252525] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3732: 
autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
[  142.252528] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3736:    
speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[  142.252531] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3740:    
hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[  142.252533] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3741:    
mono: mono_out=0x0
[  142.252536] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3744:    
dig-out=0x1e/0x0
[  142.252538] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3752:    
inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x0, aux=0x0
[  142.252541] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:3754:    
dig-in=0x1f
[  142.252689] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[  142.382457] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Headphone Playback Volume, skipped
[  142.382464] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Speaker Playback Volume, skipped
[  142.382467] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Mono Playback Volume, skipped
[  142.382470] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Line-Out Playback Volume, skipped
[  142.382473] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave PCM Playback Volume, skipped
[  142.382481] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Speaker Playback Switch, skipped
[  142.382483] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1557: 
Cannot find slave Mono Playback Switch, skipped
[  222.343895] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  222.344779] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  222.361260] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  222.380009] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  222.401256] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  222.420008] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  238.437545] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x2
[  238.437553] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x3
[  238.437557] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x4
[  238.437560] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x5
[  238.437564] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x6
[  258.485986] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  258.486008] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  273.325809] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0xa
[  273.326604] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0xa
[  283.129711] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  283.129731] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x11
[  291.633887] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x6
[  291.634702] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x6
[  297.031004] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  297.031900] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x11
[  297.051258] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x11
[  297.071257] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x11
[  297.090012] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x11
[  297.111256] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x11
[  303.678397] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x2
[  303.678404] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x3
[  303.678407] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x4
[  303.678410] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x5
[  303.678412] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0x6
[  379.632521] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  379.632539] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  379.737438] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  379.737454] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  379.835417] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  379.835432] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  379.936684] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  379.936700] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.035412] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.035428] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.136662] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.136678] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.235413] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.235428] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.335413] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.335428] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.435412] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.435427] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.535434] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.535449] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.636685] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.636701] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.735394] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.735409] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.835393] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.835408] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  380.935390] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  380.935405] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  381.035391] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  381.035406] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  381.135390] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  381.135405] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  381.235391] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  381.235406] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  381.335521] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  381.335537] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  381.435415] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  381.435431] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  381.489915] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0xa
[  381.490124] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0xa
[  411.323874] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_intel.c:1473: 
azx_pcm_prepare: bufsize=0x10000, format=0x11
[  411.323893] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1019: 
hda_codec_setup_stream: NID=0xa, stream=0x1, channel=0, format=0x11
[  415.370264] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0xa
[  415.371045] ALSA 
/usr/src/Alsa-1.0.19/alsa-driver/pci/hda/../../alsa-kernel/pci/hda/hda_codec.c:1032: 
hda_codec_cleanup_stream: NID=0xa


___________________________________________________________________


Takashi Iwai wrote :
> At Tue, 24 Feb 2009 19:47:51 -0500,
> jacques wrote:
>   
>> Hello,
>>
>> I upgraded the alsa driver with the latest snapshot without success. I 
>> also tried to record to a file directly then playing it after, still no 
>> sound. By the way, I'm not a programmer so about the line
>>
>> CONFIG_SND_DEBUG_VERBOSE=y, I added it at the end of the ./configure but I'm not sure if it was the right place... If not tell me how to do it. I'm not comfortable with kernel upgrade. Thank you for helping me further with this problem. I really appreciate your help :)
>>     
>
> No, CONFIG_* is about the kernel config for the self-made kernel.
> If you build the external ALSA modules from alsa-driver tree, pass
> --with-debug=verbose to configure.
>
> Change/add the module option "model=auto", and reload the driver.
> Adjust the mixer again, then show the kernel message when you run
> "arecord -fdat -Dspdif foo.wav".
>
>
>   
>> Here is the alsa-info output for alsa (snapshot) :
>>
>> upload=true&script=true&cardinfo=
>> !!################################
>> !!ALSA Information Script v 0.4.54
>> !!################################
>>
>> !!Script ran on: Wed Feb 25 00:37:25 UTC 2009
>>
>>
>> !!Linux Distribution
>> !!------------------
>>
>> Ubuntu 8.10 \n \l DISTRIB_ID=Ubuntu DISTRIB_DESCRIPTION="Ubuntu 8.10"
>>
>>
>> !!Kernel Information
>> !!------------------
>>
>> Kernel release:    2.6.27-7-server
>> Operating System:  GNU/Linux
>> Architecture:      x86_64
>> Processor:         unknown
>> SMP Enabled:       Yes
>>
>>
>> !!ALSA Version
>> !!------------
>>
>> Driver version:     1.0.19
>> Library version:    1.0.19.14.g59826
>> Utilities version:  1.0.19.4.g08837
>>
>>
>> !!Loaded ALSA modules
>> !!-------------------
>>
>> snd_hda_intel
>>
>>
>> !!Sound Servers on this system
>> !!----------------------------
>>
>> No sound servers found.
>>
>>
>> !!Soundcards recognised by ALSA
>> !!-----------------------------
>>
>>  0 [Intel          ]: HDA-Intel - HDA Intel
>>                       HDA Intel at 0xe3600000 irq 22
>>
>>
>> !!PCI Soundcards installed in the system
>> !!--------------------------------------
>>
>> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
>> 03:01.0 Communication controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01)
>>
>>
>> !!Advanced information - PCI Vendor/Device/Susbsystem ID's
>> !!--------------------------------------------------------
>>
>> 00:1b.0 0403: 8086:3a3e
>> 	Subsystem: 1458:a002
>>
>>
>> !!Modprobe options (Sound related)
>> !!--------------------------------
>>
>> snd-atiixp-modem: index=-2
>> snd-intel8x0m: index=-2
>> snd-via82xx-modem: index=-2
>> snd-usb-audio: index=-2
>> snd-usb-usx2y: index=-2
>> snd-usb-caiaq: index=-2
>> snd-cmipci: mpu_port=0x330 fm_port=0x388
>> snd-pcsp: index=-2
>>
>>
>> !!Loaded sound module options
>> !!--------------------------
>>
>> !!Module: snd_hda_intel
>> bdl_pos_adj : 1,-1,-1,-1,-1,-1,-1,-1
>> enable : Y,Y,Y,Y,Y,Y,Y,Y
>> enable_msi : 0
>> id : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
>> index : -1,-1,-1,-1,-1,-1,-1,-1
>> model : <NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>,<NULL>
>> position_fix : 0,0,0,0,0,0,0,0
>> power_save : 0
>> power_save_controller : Y
>> probe_mask : -1,-1,-1,-1,-1,-1,-1,-1
>> probe_only : N,N,N,N,N,N,N,N
>> single_cmd : N
>>
>>
>> !!HDA-Intel Codec information
>> !!---------------------------
>> --startcollapse--
>>
>> Codec: Realtek ALC888
>> Address: 2
>> Vendor Id: 0x10ec0888
>> Subsystem Id: 0x1458a002
>> Revision Id: 0x100001
>> No Modem Function Group found
>> Default PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0xe]: 16 20 24
>>     formats [0x1]: PCM
>> Default Amp-In caps: N/A
>> Default Amp-Out caps: N/A
>> GPIO: io=3, o=0, i=0, unsolicited=1, wake=0
>>   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
>>   IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
>>   IO[2]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
>> Node 0x02 [Audio Output] wcaps 0x11: Stereo
>>   Converter: stream=0, channel=0
>>   PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0xe]: 16 20 24
>>     formats [0x1]: PCM
>> Node 0x03 [Audio Output] wcaps 0x11: Stereo
>>   Converter: stream=0, channel=0
>>   PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0xe]: 16 20 24
>>     formats [0x1]: PCM
>> Node 0x04 [Audio Output] wcaps 0x11: Stereo
>>   Converter: stream=0, channel=0
>>   PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0xe]: 16 20 24
>>     formats [0x1]: PCM
>> Node 0x05 [Audio Output] wcaps 0x11: Stereo
>>   Converter: stream=0, channel=0
>>   PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0xe]: 16 20 24
>>     formats [0x1]: PCM
>> Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
>>   Converter: stream=0, channel=0
>>   Digital: Enabled
>>   Digital category: 0x0
>>   PCM:
>>     rates [0x5e0]: 44100 48000 88200 96000 192000
>>     bits [0x1e]: 16 20 24 32
>>     formats [0x1]: PCM
>> Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
>>   Amp-In caps: ofs=0x0b, nsteps=0x1f, stepsize=0x05, mute=1
>>   Amp-In vals:  [0x80 0x80]
>>   Converter: stream=0, channel=0
>>   SDI-Select: 0
>>   PCM:
>>     rates [0x160]: 44100 48000 96000
>>     bits [0x6]: 16 20
>>     formats [0x1]: PCM
>>   Connection: 1
>>      0x23
>> Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
>>   Amp-In caps: ofs=0x0b, nsteps=0x1f, stepsize=0x05, mute=1
>>   Amp-In vals:  [0x80 0x80]
>>   Converter: stream=0, channel=0
>>   SDI-Select: 0
>>   PCM:
>>     rates [0x160]: 44100 48000 96000
>>     bits [0x6]: 16 20
>>     formats [0x1]: PCM
>>   Connection: 1
>>      0x22
>> Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
>>   Converter: stream=0, channel=0
>>   SDI-Select: 0
>>   Digital: Enabled
>>   Digital category: 0x0
>>   PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0x1e]: 16 20 24 32
>>     formats [0x1]: PCM
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 1
>>      0x1f
>> Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
>>   Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
>>   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
>>   Connection: 10
>>      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17
>> Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x00 0x00] [0x00 0x00]
>>   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>>   Amp-Out vals:  [0x1f 0x1f]
>>   Connection: 2
>>      0x02 0x0b
>> Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x80 0x80] [0x80 0x80]
>>   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>>   Amp-Out vals:  [0x00 0x00]
>>   Connection: 2
>>      0x03 0x0b
>> Node 0x0e [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x80 0x80] [0x80 0x80]
>>   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>>   Amp-Out vals:  [0x00 0x00]
>>   Connection: 2
>>      0x04 0x0b
>> Node 0x0f [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x80 0x80] [0x80 0x80]
>>   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>>   Amp-Out vals:  [0x00 0x00]
>>   Connection: 2
>>      0x05 0x0b
>> Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x00 0x00]
>>   Pincap 0x0000003e: IN OUT HP Detect Trigger
>>   Pin Default 0x01014410: [Jack] Line Out at Ext Rear
>>     Conn = 1/8, Color = Green
>>     DefAssociation = 0x1, Sequence = 0x0
>>   Pin-ctls: 0x40: OUT
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c* 0x0d 0x0e 0x0f 0x26
>> Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x00 0x00]
>>   Pincap 0x0000003e: IN OUT HP Detect Trigger
>>   Pin Default 0x01011412: [Jack] Line Out at Ext Rear
>>     Conn = 1/8, Color = Black
>>     DefAssociation = 0x1, Sequence = 0x2
>>   Pin-ctls: 0x40: OUT
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c 0x0d* 0x0e 0x0f 0x26
>> Node 0x16 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x00 0x00]
>>   Pincap 0x00000036: IN OUT Detect Trigger
>>   Pin Default 0x01016411: [Jack] Line Out at Ext Rear
>>     Conn = 1/8, Color = Orange
>>     DefAssociation = 0x1, Sequence = 0x1
>>   Pin-ctls: 0x40: OUT
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c 0x0d 0x0e* 0x0f 0x26
>> Node 0x17 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x00 0x00]
>>   Pincap 0x00000036: IN OUT Detect Trigger
>>   Pin Default 0x01012414: [Jack] Line Out at Ext Rear
>>     Conn = 1/8, Color = Grey
>>     DefAssociation = 0x1, Sequence = 0x4
>>   Pin-ctls: 0x40: OUT
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c 0x0d 0x0e 0x0f* 0x26
>> Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x80 0x80]
>>   Pincap 0x0000373e: IN OUT HP Detect Trigger
>>     Vref caps: HIZ 50 GRD 80 100
>>   Pin Default 0x01a19c40: [Jack] Mic at Ext Rear
>>     Conn = 1/8, Color = Pink
>>     DefAssociation = 0x4, Sequence = 0x0
>>   Pin-ctls: 0x24: IN VREF_80
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c* 0x0d 0x0e 0x0f 0x26
>> Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x80 0x80]
>>   Pincap 0x0000373e: IN OUT HP Detect Trigger
>>     Vref caps: HIZ 50 GRD 80 100
>>   Pin Default 0x02a19c50: [Jack] Mic at Ext Front
>>     Conn = 1/8, Color = Pink
>>     DefAssociation = 0x5, Sequence = 0x0
>>   Pin-ctls: 0x24: IN VREF_80
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c* 0x0d 0x0e 0x0f 0x26
>> Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x80 0x80]
>>   Pincap 0x0000373e: IN OUT HP Detect Trigger
>>     Vref caps: HIZ 50 GRD 80 100
>>   Pin Default 0x0181344f: [Jack] Line In at Ext Rear
>>     Conn = 1/8, Color = Blue
>>     DefAssociation = 0x4, Sequence = 0xf
>>   Pin-ctls: 0x20: IN VREF_HIZ
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c* 0x0d 0x0e 0x0f 0x26
>> Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
>>   Amp-In vals:  [0x00 0x00]
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x80 0x80]
>>   Pincap 0x0000373e: IN OUT HP Detect Trigger
>>     Vref caps: HIZ 50 GRD 80 100
>>   Pin Default 0x02214c20: [Jack] HP Out at Ext Front
>>     Conn = 1/8, Color = Green
>>     DefAssociation = 0x2, Sequence = 0x0
>>   Pin-ctls: 0xc0: OUT HP VREF_HIZ
>>   Unsolicited: tag=00, enabled=0
>>   Connection: 5
>>      0x0c* 0x0d 0x0e 0x0f 0x26
>> Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
>>   Pincap 0x00000020: IN
>>   Pin Default 0x593301f0: [N/A] CD at Int ATAPI
>>     Conn = ATAPI, Color = Unknown
>>     DefAssociation = 0xf, Sequence = 0x0
>>     Misc = NO_PRESENCE
>>   Pin-ctls: 0x20: IN
>> Node 0x1d [Pin Complex] wcaps 0x400000: Mono
>>   Pincap 0x00000020: IN
>>   Pin Default 0x4005e601: [N/A] Line Out at Ext N/A
>>     Conn = Optical, Color = White
>>     DefAssociation = 0x0, Sequence = 0x1
>>   Pin-ctls: 0x20: IN
>> Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
>>   Pincap 0x00000010: OUT
>>   Pin Default 0x014b6130: [Jack] SPDIF Out at Ext Rear
>>     Conn = Comb, Color = Orange
>>     DefAssociation = 0x3, Sequence = 0x0
>>     Misc = NO_PRESENCE
>>   Pin-ctls: 0x40: OUT
>>   Connection: 1
>>      0x06
>> Node 0x1f [Pin Complex] wcaps 0x400200: Mono Digital
>>   Pincap 0x00000020: IN
>>   Pin Default 0x01cb7160: [Jack] SPDIF In at Ext Rear
>>     Conn = Comb, Color = Yellow
>>     DefAssociation = 0x6, Sequence = 0x0
>>     Misc = NO_PRESENCE
>>   Pin-ctls: 0x20: IN
>> Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
>>   Processing caps: benign=0, ncoeff=17
>>   Processing Coefficient: 0x00
>>   Coefficient Index: 0x0a
>> Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
>>   Connection: 11
>>      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
>> Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
>>   Connection: 11
>>      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
>> Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
>> Node 0x25 [Audio Output] wcaps 0x11: Stereo
>>   Converter: stream=0, channel=0
>>   PCM:
>>     rates [0x560]: 44100 48000 96000 192000
>>     bits [0xe]: 16 20 24
>>     formats [0x1]: PCM
>> Node 0x26 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-In vals:  [0x00 0x00] [0x80 0x80]
>>   Amp-Out caps: ofs=0x1f, nsteps=0x1f, stepsize=0x05, mute=0
>>   Amp-Out vals:  [0x00 0x00]
>>   Connection: 2
>>      0x25 0x0b
>> Codec: Intel G45 DEVELK
>> Address: 3
>> Vendor Id: 0x80862803
>> Subsystem Id: 0x80860101
>> Revision Id: 0x100000
>> No Modem Function Group found
>> Default PCM:
>>     rates [0x0]:
>>     bits [0x0]:
>>     formats [0x0]:
>> Default Amp-In caps: N/A
>> Default Amp-Out caps: N/A
>> GPIO: io=0, o=0, i=0, unsolicited=0, wake=0
>> Node 0x02 [Audio Output] wcaps 0x6211: 8-Channels Digital
>>   Converter: stream=0, channel=0
>>   Digital: Enabled
>>   Digital category: 0x0
>>   PCM:
>>     rates [0x7f0]: 32000 44100 48000 88200 96000 176400 192000
>>     bits [0x1e]: 16 20 24 32
>>     formats [0x5]: PCM AC3
>> Node 0x03 [Pin Complex] wcaps 0x40739d: 8-Channels Digital Amp-Out CP
>>   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
>>   Amp-Out vals:  [0x00 0x00]
>>   Pincap 0x00000094: OUT Detect HDMI
>>   Pin Default 0x18560010: [Jack] Digital Out at Int HDMI
>>     Conn = Digital, Color = Unknown
>>     DefAssociation = 0x1, Sequence = 0x0
>>   Pin-ctls: 0x40: OUT
>>   Unsolicited: tag=08, enabled=1
>>   Connection: 1
>>      0x02
>> --endcollapse--
>>
>>
>> !!ALSA Device nodes
>> !!-----------------
>>
>> crw-rw---- 1 root audio 116,  0 Feb 24 19:26 /dev/snd/controlC0
>> crw-rw---- 1 root audio 116,  6 Feb 24 19:26 /dev/snd/hwC0D2
>> crw-rw---- 1 root audio 116,  7 Feb 24 19:26 /dev/snd/hwC0D3
>> crw-rw---- 1 root audio 116, 24 Feb 24 19:26 /dev/snd/pcmC0D0c
>> crw-rw---- 1 root audio 116, 16 Feb 24 19:26 /dev/snd/pcmC0D0p
>> crw-rw---- 1 root audio 116, 25 Feb 24 19:35 /dev/snd/pcmC0D1c
>> crw-rw---- 1 root audio 116, 17 Feb 24 19:34 /dev/snd/pcmC0D1p
>> crw-rw---- 1 root audio 116, 26 Feb 24 19:26 /dev/snd/pcmC0D2c
>> crw-rw---- 1 root audio 116, 19 Feb 24 19:26 /dev/snd/pcmC0D3p
>> crw-rw---- 1 root audio 116,  1 Feb 24 19:26 /dev/snd/seq
>> crw-rw---- 1 root audio 116, 33 Feb 24 19:26 /dev/snd/timer
>>
>>
>> !!Aplay/Arecord output
>> !!------------
>>
>> APLAY
>>
>> **** List of PLAYBACK Hardware Devices ****
>> card 0: Intel [HDA Intel], device 0: ALC888 Analog [ALC888 Analog]
>>   Subdevices: 1/1
>>   Subdevice #0: subdevice #0
>> card 0: Intel [HDA Intel], device 1: ALC888 Digital [ALC888 Digital]
>>   Subdevices: 1/1
>>   Subdevice #0: subdevice #0
>> card 0: Intel [HDA Intel], device 3: INTEL HDMI [INTEL HDMI]
>>   Subdevices: 1/1
>>   Subdevice #0: subdevice #0
>>
>> ARECORD
>>
>> **** List of CAPTURE Hardware Devices ****
>> card 0: Intel [HDA Intel], device 0: ALC888 Analog [ALC888 Analog]
>>   Subdevices: 1/1
>>   Subdevice #0: subdevice #0
>> card 0: Intel [HDA Intel], device 1: ALC888 Digital [ALC888 Digital]
>>   Subdevices: 1/1
>>   Subdevice #0: subdevice #0
>> card 0: Intel [HDA Intel], device 2: ALC888 Analog [ALC888 Analog]
>>   Subdevices: 1/1
>>   Subdevice #0: subdevice #0
>>
>> !!Amixer output
>> !!-------------
>>
>> !!-------Mixer controls for card 0 [Intel]
>>
>> Card hw:0 'Intel'/'HDA Intel at 0xe3600000 irq 22'
>>   Mixer name	: 'Intel G45 DEVELK'
>>   Components	: 'HDA:10ec0888,1458a002,00100001 HDA:80862803,80860101,00100000'
>>   Controls      : 44
>>   Simple ctrls  : 23
>> Simple mixer control 'Master',0
>>   Capabilities: pvolume pvolume-joined pswitch pswitch-joined
>>   Playback channels: Mono
>>   Limits: Playback 0 - 31
>>   Mono: Playback 31 [100%] [0.00dB] [on]
>> Simple mixer control 'Headphone',0
>>   Capabilities: pswitch
>>   Playback channels: Front Left - Front Right
>>   Mono:
>>   Front Left: Playback [off]
>>   Front Right: Playback [off]
>> Simple mixer control 'PCM',0
>>   Capabilities: pvolume
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 255
>>   Mono:
>>   Front Left: Playback 255 [100%] [0.00dB]
>>   Front Right: Playback 255 [100%] [0.00dB]
>> Simple mixer control 'Front',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 31 [100%] [0.00dB] [on]
>>   Front Right: Playback 31 [100%] [0.00dB] [on]
>> Simple mixer control 'Front Mic',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-34.50dB] [off]
>>   Front Right: Playback 0 [0%] [-34.50dB] [off]
>> Simple mixer control 'Front Mic Boost',0
>>   Capabilities: volume
>>   Playback channels: Front Left - Front Right
>>   Capture channels: Front Left - Front Right
>>   Limits: 0 - 3
>>   Front Left: 0 [0%]
>>   Front Right: 0 [0%]
>> Simple mixer control 'Surround',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-46.50dB] [off]
>>   Front Right: Playback 0 [0%] [-46.50dB] [off]
>> Simple mixer control 'Center',0
>>   Capabilities: pvolume pvolume-joined pswitch pswitch-joined
>>   Playback channels: Mono
>>   Limits: Playback 0 - 31
>>   Mono: Playback 0 [0%] [-46.50dB] [off]
>> Simple mixer control 'LFE',0
>>   Capabilities: pvolume pvolume-joined pswitch pswitch-joined
>>   Playback channels: Mono
>>   Limits: Playback 0 - 31
>>   Mono: Playback 0 [0%] [-46.50dB] [off]
>> Simple mixer control 'Side',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-46.50dB] [off]
>>   Front Right: Playback 0 [0%] [-46.50dB] [off]
>> Simple mixer control 'Line',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-34.50dB] [off]
>>   Front Right: Playback 0 [0%] [-34.50dB] [off]
>> Simple mixer control 'CD',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-34.50dB] [off]
>>   Front Right: Playback 0 [0%] [-34.50dB] [off]
>> Simple mixer control 'Mic',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-34.50dB] [off]
>>   Front Right: Playback 0 [0%] [-34.50dB] [off]
>> Simple mixer control 'Mic Boost',0
>>   Capabilities: volume
>>   Playback channels: Front Left - Front Right
>>   Capture channels: Front Left - Front Right
>>   Limits: 0 - 3
>>   Front Left: 0 [0%]
>>   Front Right: 0 [0%]
>> Simple mixer control 'IEC958',0
>>   Capabilities: pswitch pswitch-joined cswitch cswitch-joined
>>   Playback channels: Mono
>>   Capture channels: Mono
>>   Mono: Playback [on] Capture [on]
>> Simple mixer control 'IEC958 Default PCM',0
>>   Capabilities: pswitch pswitch-joined
>>   Playback channels: Mono
>>   Mono: Playback [on]
>> Simple mixer control 'IEC958',1
>>   Capabilities: pswitch pswitch-joined
>>   Playback channels: Mono
>>   Mono: Playback [on]
>> Simple mixer control 'Capture',0
>>   Capabilities: cvolume cswitch
>>   Capture channels: Front Left - Front Right
>>   Limits: Capture 0 - 31
>>   Front Left: Capture 0 [0%] [-16.50dB] [off]
>>   Front Right: Capture 0 [0%] [-16.50dB] [off]
>> Simple mixer control 'Capture',1
>>   Capabilities: cvolume cswitch
>>   Capture channels: Front Left - Front Right
>>   Limits: Capture 0 - 31
>>   Front Left: Capture 0 [0%] [-16.50dB] [off]
>>   Front Right: Capture 0 [0%] [-16.50dB] [off]
>> Simple mixer control 'Beep',0
>>   Capabilities: pvolume pswitch
>>   Playback channels: Front Left - Front Right
>>   Limits: Playback 0 - 31
>>   Mono:
>>   Front Left: Playback 0 [0%] [-34.50dB] [off]
>>   Front Right: Playback 0 [0%] [-34.50dB] [off]
>> Simple mixer control 'Channel Mode',0
>>   Capabilities: enum
>>   Items: '6ch' '8ch'
>>   Item0: '6ch'
>> Simple mixer control 'Input Source',0
>>   Capabilities: cenum
>>   Items: 'Mic' 'Front Mic' 'Line' 'CD'
>>   Item0: 'CD'
>> Simple mixer control 'Input Source',1
>>   Capabilities: cenum
>>   Items: 'Mic' 'Front Mic' 'Line' 'CD'
>>   Item0: 'CD'
>>
>>
>> !!Alsactl output
>> !!-------------
>>
>> --startcollapse--
>> state.Intel {
>> 	control.1 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -4650
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'Front Playback Volume'
>> 		value.0 31
>> 		value.1 31
>> 	}
>> 	control.2 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Front Playback Switch'
>> 		value.0 true
>> 		value.1 true
>> 	}
>> 	control.3 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -4650
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'Surround Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.4 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Surround Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.5 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 1
>> 		comment.range '0 - 31'
>> 		comment.dbmin -4650
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'Center Playback Volume'
>> 		value 0
>> 	}
>> 	control.6 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 1
>> 		comment.range '0 - 31'
>> 		comment.dbmin -4650
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'LFE Playback Volume'
>> 		value 0
>> 	}
>> 	control.7 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'Center Playback Switch'
>> 		value false
>> 	}
>> 	control.8 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'LFE Playback Switch'
>> 		value false
>> 	}
>> 	control.9 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -4650
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'Side Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.10 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Side Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.11 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Headphone Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.12 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -3450
>> 		comment.dbmax 1200
>> 		iface MIXER
>> 		name 'CD Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.13 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'CD Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.14 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -3450
>> 		comment.dbmax 1200
>> 		iface MIXER
>> 		name 'Line Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.15 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Line Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.16 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -3450
>> 		comment.dbmax 1200
>> 		iface MIXER
>> 		name 'Mic Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.17 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 3'
>> 		comment.dbmin 0
>> 		comment.dbmax 3000
>> 		iface MIXER
>> 		name 'Mic Boost'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.18 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Mic Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.19 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -3450
>> 		comment.dbmax 1200
>> 		iface MIXER
>> 		name 'Front Mic Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.20 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 3'
>> 		comment.dbmin 0
>> 		comment.dbmax 3000
>> 		iface MIXER
>> 		name 'Front Mic Boost'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.21 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Front Mic Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.22 {
>> 		comment.access 'read write'
>> 		comment.type ENUMERATED
>> 		comment.count 1
>> 		comment.item.0 '6ch'
>> 		comment.item.1 '8ch'
>> 		iface MIXER
>> 		name 'Channel Mode'
>> 		value '6ch'
>> 	}
>> 	control.23 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Capture Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.24 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Capture Switch'
>> 		index 1
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.25 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -1650
>> 		comment.dbmax 3000
>> 		iface MIXER
>> 		name 'Capture Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.26 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -1650
>> 		comment.dbmax 3000
>> 		iface MIXER
>> 		name 'Capture Volume'
>> 		index 1
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.27 {
>> 		comment.access 'read write'
>> 		comment.type ENUMERATED
>> 		comment.count 1
>> 		comment.item.0 Mic
>> 		comment.item.1 'Front Mic'
>> 		comment.item.2 Line
>> 		comment.item.3 CD
>> 		iface MIXER
>> 		name 'Input Source'
>> 		value CD
>> 	}
>> 	control.28 {
>> 		comment.access 'read write'
>> 		comment.type ENUMERATED
>> 		comment.count 1
>> 		comment.item.0 Mic
>> 		comment.item.1 'Front Mic'
>> 		comment.item.2 Line
>> 		comment.item.3 CD
>> 		iface MIXER
>> 		name 'Input Source'
>> 		index 1
>> 		value CD
>> 	}
>> 	control.29 {
>> 		comment.access read
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Con Mask'
>> 		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.30 {
>> 		comment.access read
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Pro Mask'
>> 		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.31 {
>> 		comment.access 'read write'
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Default'
>> 		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.32 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Switch'
>> 		value true
>> 	}
>> 	control.33 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Default PCM Playback Switch'
>> 		value true
>> 	}
>> 	control.34 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Capture Switch'
>> 		value true
>> 	}
>> 	control.35 {
>> 		comment.access read
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Capture Default'
>> 		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.36 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 31'
>> 		comment.dbmin -3450
>> 		comment.dbmax 1200
>> 		iface MIXER
>> 		name 'Beep Playback Volume'
>> 		value.0 0
>> 		value.1 0
>> 	}
>> 	control.37 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 2
>> 		iface MIXER
>> 		name 'Beep Playback Switch'
>> 		value.0 false
>> 		value.1 false
>> 	}
>> 	control.38 {
>> 		comment.access 'read write'
>> 		comment.type INTEGER
>> 		comment.count 1
>> 		comment.range '0 - 31'
>> 		comment.dbmin -4650
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'Master Playback Volume'
>> 		value 31
>> 	}
>> 	control.39 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'Master Playback Switch'
>> 		value true
>> 	}
>> 	control.40 {
>> 		comment.access read
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Con Mask'
>> 		index 1
>> 		value '0fff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.41 {
>> 		comment.access read
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Pro Mask'
>> 		index 1
>> 		value '0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.42 {
>> 		comment.access 'read write'
>> 		comment.type IEC958
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Default'
>> 		index 1
>> 		value '0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
>> 	}
>> 	control.43 {
>> 		comment.access 'read write'
>> 		comment.type BOOLEAN
>> 		comment.count 1
>> 		iface MIXER
>> 		name 'IEC958 Playback Switch'
>> 		index 1
>> 		value true
>> 	}
>> 	control.44 {
>> 		comment.access 'read write user'
>> 		comment.type INTEGER
>> 		comment.count 2
>> 		comment.range '0 - 255'
>> 		comment.tlv '0000000100000008ffffec1400000014'
>> 		comment.dbmin -5100
>> 		comment.dbmax 0
>> 		iface MIXER
>> 		name 'PCM Playback Volume'
>> 		value.0 255
>> 		value.1 255
>> 	}
>> }
>> --endcollapse--
>>
>>
>> !!All Loaded Modules
>> !!------------------
>>
>> Module
>> xt_tcpudp
>> xt_mac
>> nf_conntrack_ipv4
>> xt_state
>> nf_conntrack
>> ppdev
>> ipv6
>> iptable_filter
>> ip_tables
>> x_tables
>> ac
>> coretemp
>> it87
>> hwmon_vid
>> lp
>> loop
>> snd_hda_codec_intelhdmi
>> snd_hda_codec_realtek
>> snd_hda_intel
>> snd_hda_codec
>> snd_hwdep
>> snd_pcm_oss
>> snd_mixer_oss
>> snd_pcm
>> parport_serial
>> snd_seq_dummy
>> snd_seq_oss
>> button
>> parport_pc
>> parport
>> snd_seq_midi
>> snd_rawmidi
>> pcspkr
>> snd_seq_midi_event
>> snd_seq
>> snd_timer
>> evdev
>> snd_seq_device
>> snd
>> soundcore
>> snd_page_alloc
>> shpchp
>> intel_agp
>> pci_hotplug
>> xfs
>> sr_mod
>> cdrom
>> pata_it8213
>> pata_acpi
>> sd_mod
>> crc_t10dif
>> sg
>> usbhid
>> hid
>> ata_generic
>> sata_promise
>> ahci
>> libata
>> scsi_mod
>> dock
>> r8169
>> ehci_hcd
>> uhci_hcd
>> usbcore
>> raid10
>> raid456
>> async_xor
>> async_memcpy
>> async_tx
>> xor
>> raid1
>> raid0
>> multipath
>> linear
>> md_mod
>> thermal
>> processor
>> fan
>> fbcon
>> tileblit
>> font
>> bitblit
>> softcursor
>> fuse
>>
>>
>>
>>
>>     
>>> At Sun, 22 Feb 2009 10:57:24 -0500,
>>> jacques wrote:
>>>   
>>>       
>>>> Hello,
>>>>
>>>> I have a giga-byte GA-EG43-S2H with an integrated REALTEK ALC888 sound 
>>>> card. I'm unable to use the digital INPUT while recording or using pipe 
>>>> (arecord -M -D iec958 -f dat | aplay -D iec958 -f dat). Also, the 
>>>> giga-byte GA-EG41-S2H has the same problem (uses the same sound 
>>>> chipset). The giga-byte GA-EP45-UD3R is working perfectly but it uses a 
>>>> different sound chip (ALC889A). I tried a lot of things like changing 
>>>> snd-hda-intel model (auto, 6stack-dig, 3stack-dig, etc). I upgraded the 
>>>> ALSA sound driver to the latest version (1.0.19) and also used the 
>>>> snapshot. My distribution is Ubuntu 8.10 (server edition) 64 bits. I 
>>>> also installed the desktop version of it without success. I tested the 
>>>> digital input on Windows operating system and it works perfectly. Now, 
>>>> I'm not sure if I'm missing something with the configuration or it is a 
>>>> problem with the ALSA driver or the kernel module itself.
>>>>     
>>>>         
>>> What about simply recording to a file?
>>>
>>> 	% arecord -Diec958 -fdat foo.wav
>>>
>>> Also try to build with CONFIG_SND_DEBUG_VERBOSE=y once to check how
>>> the PCM stream is assigned.
>>>
>>>   
>>>       
>>>> Look at the outputs from alsa-info script (computer outputs for details):
>>>> http://www.alsa-project.org/db/?f=068933737fa64bc43928b06d2f4b4559986e6439
>>>>     
>>>>         
>>> It shows you are using 1.0.17.
>>> Use the latest driver below, run alsa-info with --no-upload, and
>>> attach the content.
>>>
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>>>     ftp://ftp.kernel.org/pub/linux/kernel/people/tiwai/snapshot/alsa-driver-snapshot.tar.gz
>>>
>>>
>>> thanks,
>>>
>>> Takashi
>>>
>>>   
>>>       
>
>   

