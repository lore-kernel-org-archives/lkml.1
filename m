Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYBNQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYBNQVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYBNQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:21:09 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:54386 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYBNQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:21:07 -0500
Date: Thu, 14 Feb 2008 17:21:04 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: Disk schedulers
Message-ID: <20080214162104.GA5347@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 14 Feb 2008 17:21:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

whom should I blame about disk schedulers?

I have the following setup:
1Gb network
2GB RAM
disk write speed about 20MB/s

If I'm scping file (about 500MB) from the network (which is faster than the
local disk), any process is totally unable to read anything from the local disk
till the scp finishes. It is not caused by low free memory, while scping
I have 500MB of free memory (not cached or buffered).

I tried cfq and anticipatory scheduler, none is different.

-- 
Luká¹ Hejtmánek
