Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbYBNKiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbYBNKiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 05:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYBNKiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 05:38:06 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:40977 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYBNKiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 05:38:05 -0500
Date: Thu, 14 Feb 2008 11:38:01 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc1 regression - IBM ACPI backlight
Message-ID: <20080214103801.GB4366@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 14 Feb 2008 11:38:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as of 2.6.25-rc1, there is no more /sys/class/backlight/acpi_video1 which
controlled LVDS backlight on Lenovo ThinkPad T61. There is still acpi_video0
which seems to have sane values but echo N > brightness has no effect at all.

thinkpad_acpi module reports that ACPI controlled backlight is present.

-- 
Luká¹ Hejtmánek
