Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZDEIMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZDEIMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbZDEILr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:11:47 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:55369 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757676AbZDEILp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:11:45 -0400
Message-ID: <49D867BE.1010700@krogh.cc>
Date: Sun, 05 Apr 2009 10:11:42 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: e1000: eth2: e1000_clean_tx_irq: Detected Tx Unit Hang
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a 2.6.27.20 system in production, the e1000 drivers seem pretty 
"noisy" allthough everything appears to work excellent.

dmesg here: http://krogh.cc/~jesper/dmesg-ko-2.6.27.20.txt

[476197.380486] e1000: eth3: e1000_clean_tx_irq: Detected Tx Unit Hang
[476197.380488]   Tx Queue             <0>
[476197.380489]   TDH                  <c>
[476197.380490]   TDT                  <63>
[476197.380490]   next_to_use          <63>
[476197.380491]   next_to_clean        <b>
[476197.380491] buffer_info[next_to_clean]
[476197.380492]   time_stamp           <10717579a>
[476197.380492]   next_to_watch        <f>
[476197.380493]   jiffies              <107175a3e>
[476197.380494]   next_to_watch.status <0>

The system has been up for 14 days but the dmesg-buffer has allready 
overflown with these.

Configuratoin is a 4 x 1GbitE bond all with Intel NICs

06:01.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet 
Controller (Copper) (rev 03)
06:01.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet 
Controller (Copper) (rev 03)
06:02.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet 
Controller (Copper) (rev 03)
06:02.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet 
Controller (Copper) (rev 03)



-- 
Jesper
