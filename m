Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXKTOx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXKTOx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbXKTOxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:53:06 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:54931 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbXKTOxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:53:05 -0500
X-Greylist: delayed 888 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 09:53:05 EST
Date: Tue, 20 Nov 2007 15:38:04 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Auke Kok <auke-jan.h.kok@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: e1000 driver problems
Message-ID: <20071120143803.GA5638@ics.muni.cz>
References: <20061017205316.25914.qmail@web83109.mail.mud.yahoo.com> <45354850.6050900@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45354850.6050900@intel.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 Nov 2007 15:38:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have laptop thinkpad T61 with 82566MM Gigabit Network Connection (rev 03)
(8086:1049). I have kernel 2.6.24-rc3. E1000E driver does not work (the card
is not detected although it is PCI-E), with E1000 driver, it works mostly OK
unless I force speed to 100Mbits. (ethtool -s eth0 autoneg off speed 100)

I got message about device hang:
Nov 20 10:57:24 anubis kernel: [  212.307502] e1000: eth0: e1000_watchdog:
10/100 speed: disabling TSO
Nov 20 11:03:02 anubis kernel: [  242.811474]   Tx Queue             <0>
Nov 20 11:03:02 anubis kernel: [  242.811476]   TDH                  <80>
Nov 20 11:03:02 anubis kernel: [  242.811478]   TDT                  <81>
Nov 20 11:03:02 anubis kernel: [  242.811480]   next_to_use          <81>
Nov 20 11:03:02 anubis kernel: [  242.811482]   next_to_clean        <80>
Nov 20 11:03:02 anubis kernel: [  242.811484] buffer_info[next_to_clean]
Nov 20 11:03:02 anubis kernel: [  242.811486]   time_stamp <100079cdf>
Nov 20 11:03:02 anubis kernel: [  242.811488]   next_to_watch        <80>
Nov 20 11:03:02 anubis kernel: [  242.811489]   jiffies <100079e68>
Nov 20 11:03:02 anubis kernel: [  242.811491]   next_to_watch.status <0>
Nov 20 11:03:04 anubis kernel: [  243.000047]   Tx Queue             <0>
Nov 20 11:03:04 anubis kernel: [  243.000049]   TDH                  <80>
Nov 20 11:03:04 anubis kernel: [  243.000051]   TDT                  <81>
Nov 20 11:03:04 anubis kernel: [  243.000053]   next_to_use          <81>
and so on.

Is it known problem?


-- 
Luká¹ Hejtmánek
