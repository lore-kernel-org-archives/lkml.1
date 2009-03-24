Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZCXMKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZCXMKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZCXMJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:09:52 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:46287 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZCXMJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:09:51 -0400
Date: Tue, 24 Mar 2009 13:09:48 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: tg3 driver fails to load firmware (2.6.29)
Message-ID: <20090324120948.GO12613@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the log:

Mar 24 09:02:42 proxy-cvk-2 kernel: [   39.078323] tg3 0000:02:02.0: PME# disabled
Mar 24 09:02:42 proxy-cvk-2 kernel: [   40.600196] tg3 0000:02:02.1: firmware: requesting tigon/tg3_tso.bin
Mar 24 09:02:42 proxy-cvk-2 kernel: [   41.723404] tg3: eth0: Link is up at 1000 Mbps, full duplex.
Mar 24 09:02:42 proxy-cvk-2 kernel: [   41.723458] tg3: eth0: Flow control is on for TX and on for RX.
Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599130] eth1: Failed to load firmware "tigon/tg3_tso.bin"
Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599184] eth1: TSO capability disabled.
Mar 24 09:02:42 proxy-cvk-2 kernel: [  100.599241] tg3 0000:02:02.1: PME# disabled

but:

# ll /lib/firmware/2.6.29/tigon/tg3_tso.bin
-rw-r--r-- 1 root root 7004 Mar 24 09:24 /lib/firmware/2.6.29/tigon/tg3_tso.bin
