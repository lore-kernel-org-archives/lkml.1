Return-Path: <linux-kernel-owner+w=401wt.eu-S966054AbXCTAvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966054AbXCTAvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 20:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966059AbXCTAvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 20:51:11 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:41385 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966054AbXCTAvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 20:51:09 -0400
Date: Tue, 20 Mar 2007 01:52:28 +0100
From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: UDP packets scheduling
Message-ID: <20070320005228.GN22880@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Mar 2007 01:51:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

can anyone suggest me a proper way how to schedule UDP packets to transmit at
some given rate?

E.g., I have two boxes both having 10 GE interfaces. One box is able to
transmit at 9.9Gbps, the other one is able to receive only at about 5.5Gbps.
Flow control must be turned off for some other reason.

How can I put delay between subsequent msg sends to achieve desired
packet rate without loses, e.g., 3.5Gbps without bursts? Even nanosleep()
with the lowest possible delay seems to be too much delay. Busy loop with
clock_gettime(3) works OK on SMP boxes, but on UP it causes problems.

-- 
Luká¹ Hejtmánek
