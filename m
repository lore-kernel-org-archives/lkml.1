Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZDUOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZDUOVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZDUOVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:21:43 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:29138 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750975AbZDUOVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:21:42 -0400
Message-ID: <547506.26789.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: ZlgJZ_EVM1kJ0PxUj9h4Hl8I_gNp_fei1i6KXBhiEvclXh.1Yrv2OuLcyv33ZRx4aB8LLxf11wOKsnirtxfYf0oiK04gIG1qrf2moCFaslvFrQ8vrltOBp5DlFuEA_DqXnW71WiProWlfF90KzNiuAQM3S7KmOdalFg.1FdQhFwMdQ04Z3zmkjY15o1epuUmWS4lXzYMPtLyq2qEiIqEMOehm4EalF3h5Cc0y8xgIXCH_s8weT6.NxIdo2vsypgEBoEjCYEksUNfbQBXkp1Qclg_bENlvoJv1Ew7H_gL_JWPeRk6vbUJMx6KO6PuIEBnk8972mcEzHKl43It3sYuOYef
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Tue, 21 Apr 2009 07:21:41 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Booting 2.6.30-rc2-git7 very slow
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, [please CC me on replies, as I am not subscribed]

 booting  2.6.30-rc2-git7 on a HP/DL380G3 (x86_64, RHEL4.3, 64 bit userspace) is much slower that it used to be. It seems I run into timeouts when [trying to] load intel and tg3 microcodes:

[   14.478892] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[   74.476741] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[  134.476638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[  194.476637] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[  254.476493] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[  254.718489] Microcode Update Driver: v2.00 removed.

 So, we see 60 seconds for eaoch of the CPUs

[  255.273426] tg3 0000:03:01.0: PME# disabled
[  257.833769] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
[  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
[  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
[  329.640463] eth1: TSO capability disabled.
[  329.640487] tg3 0000:03:01.1: PME# disabled
[  333.081753] tg3: eth1: Link is up at 1000 Mbps, full duplex.
[  333.081759] tg3: eth1: Flow control is off for TX and off for RX.

 We see 60 seconds for eth1, complaining about a failed firmware load.
/lib/firmware/tigon/tg3_tso.bin does exist and is from the current
build.

 
So, any ideas? Config is attached

Cheers
Martin
------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de

