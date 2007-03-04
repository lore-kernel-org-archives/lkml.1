Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbXCDJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbXCDJFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 04:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbXCDJFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 04:05:40 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2543 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXCDJFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 04:05:38 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc2-mm1
Date: Sun, 4 Mar 2007 10:07:31 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041007.31800.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	I'm experiencing weird system hangs with recent -mm. After a few hours of uptime for no
obvious reason system hangs and is (almost) unusable until reset.

a few facts:

- this happens on random basis without anything obvious that could trigger it 
- if some music is played and system hangs the music starts looping in thight loop causing weird
  sound effects
- sometimes I'm able to switch from X to console, it takes a few seconds to switch though
- system is eating 100% CPU what is shown by my laptop fans
- when I switch to console I can issue SysRq commands but they do not work i.e.:
  SysRq + P shows only the first line: "SysRq: Show Regs"
- in console in which I can log into the system I'm unable to type
- in console where syslog is logging *.* I'm able to type
- if the wifi card was plugged into the system before the hang happend the networking seems to work ok
- when I reattach my pcmcia wifi card it doesn't get detected (nothing happens)
- when I try to login to my laptop from remote machine the line "login:" and that's it, nothing
  more happens
- system logs show nothing interesting as even if there is some usable debug info I'm unable to 
  SysRq + S and read it after reboot

With 2.6.20-mm1 it happened as well. I get the feeling that 2.6.20-rc2-mm1 needs a bit more uptime
to hit this bug.

Regards,

	Mariusz Kozlowski
