Return-Path: <linux-kernel-owner+w=401wt.eu-S934716AbXEHIfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbXEHIfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 04:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934699AbXEHIfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 04:35:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:15450 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934592AbXEHIfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 04:35:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=RHOgWtedccJy1mzch1LRfuVtpwL1ZM7x2p+DtyhjUWXOZAB/+pjtx4516JHg7PCS7y9sd/1DbuMygjlyU9zb3bma8brZM/aF25GIOcNATWzY3IQkA91iZe07zkxa66YVofdauOv4H4aWDKUX7YZYhv7oFr2Lij4AdCC//OaEgt0=
Message-ID: <46403642.7020501@googlemail.com>
Date: Tue, 08 May 2007 10:35:14 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-git8+ BUG: NMI Watchdog detected LOCKUP on CPU1
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

/ filesystem was full

[39525.460000] BUG: NMI Watchdog detected LOCKUP on CPU1, eip 08056990, registers:
[39525.468000] Modules linked in: loop ipt_MASQUERADE iptable_nat nf_nat autofs4 af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss evdev snd_pcm intel_agp snd_timer snd agpgart soundcore i2c_i801 snd_page_alloc ide_cd cdrom rtc unix
[39525.518000] CPU:    1
[39525.518000] EIP:    0073:[<08056990>]    Not tainted VLI
[39525.518000] EFLAGS: 00000202   (2.6.21-ga989705c #187)
[39525.529000] EIP is at 0x8056990
[39525.529000] eax: 6e560d60   ebx: 0000000b   ecx: 00000000   edx: 000dd15e
[39525.541000] esi: 00000000   edi: 6e560220   ebp: bfeb0a58   esp: bfeb0990
[39525.547000] ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 007b
[39525.553000] Process line (pid: 4277, ti=cf200000 task=f6f560b0 task.ti=cf200000)
[39525.560000] Kernel panic - not syncing: Aiee, killing interrupt handler!

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git8/git-console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git8/git-config

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
