Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYEEICz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYEEICz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbYEEICd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:02:33 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:44412 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbYEEICa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:02:30 -0400
Date: Mon, 5 May 2008 10:02:27 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080505080227.GA5499@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 05 May 2008 10:02:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as of some high versions of 2.6.25-gitXX and 2.6.26-rc1, USB devices pluged
into a dock (minidock for Lenovo ThinkPad T61) are not discoverred until
I reload ehci-hcd module with already plugged device.

Also minor omnipresent bug, most of the time, I got garbage message instead of
the message "machine restart" when restarting. I think, the message is OK if
I boot up and then immediatelly restart. If I restart after some time, only
garbage is displayed (ASCII chars with value above 127 mostly).

-- 
Luká¹ Hejtmánek
