Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYCCVzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYCCVzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYCCVzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:55:01 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43070 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYCCVzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:55:00 -0500
Date: Mon, 3 Mar 2008 22:54:56 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25 possible regression usbfs options ignored?
Message-ID: <20080303215456.GA7747@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 03 Mar 2008 22:54:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using 2.6.25-rc3. It seems that options for usbfs (devgid and devmode) are
ignored.

# mount | grep usbfs
none on /proc/bus/usb type usbfs (rw,devgid=46,devmode=0664)

/proc/bus/usb# ls -l
total 0
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 001
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 002
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 003
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 004
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 005
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 006
dr-xr-xr-x 2 root root 0 2008-03-03 10:41 007
-r--r--r-- 1 root root 0 2008-03-03 22:30 devices

or am I just someting missing?

-- 
Luká¹ Hejtmánek
