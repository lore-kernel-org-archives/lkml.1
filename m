Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbXGHA5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbXGHA5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 20:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXGHA52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 20:57:28 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:51715 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbXGHA51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 20:57:27 -0400
Date: Sun, 8 Jul 2007 02:58:07 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: SLAB corruption
Message-ID: <20070708005807.GV3885@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@ics.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sun, 08 Jul 2007 02:57:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to get to work InfiniBand card (Mellanox) in Xen and DomU. 

If I use SLAB_DEBUG I got the following message:
Slab corruption: start=ffff880098f513b8, len=256
Redzone: 0x1600000016/0x1700000017.
Last user: <0000001800000018>(0x1800000018)
000: 17 00 00 00 17 00 00 00 18 00 00 00 18 00 00 00
010: 19 00 00 00 19 00 00 00 1a 00 00 00 1a 00 00 00
020: 1b 00 00 00 1b 00 00 00 1c 00 00 00 1c 00 00 00
030: 1d 00 00 00 1d 00 00 00 1e 00 00 00 1e 00 00 00
040: 1f 00 00 00 1f 00 00 00 00 00 00 00 00 00 00 00
050: 01 00 00 00 01 00 00 00 02 00 00 00 02 00 00 00
Prev obj: start=0000000398f5120b, len=256
Unable to handle kernel paging request at 0000000398f5130b RIP:
 <ffffffff80277313> print_objinfo+0x22/0xde


Could anyone give me some hints how to track down the SLAB corruption?

-- 
Luká¹ Hejtmánek
