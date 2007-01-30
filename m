Return-Path: <linux-kernel-owner+w=401wt.eu-S965647AbXA3Rl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647AbXA3Rl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 12:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXA3Rl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 12:41:56 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:43866 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965647AbXA3Rlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 12:41:55 -0500
X-YMail-OSG: iyAHHJwVM1ll8EXcM.qSBHYv6TdK3MF1ODOu9KG3jXHsWOvVWhyExO5oCmKGx9YT5wA-
Message-ID: <45BF81CF.2060801@dogpad.net>
Date: Tue, 30 Jan 2007 11:35:11 -0600
From: Joe Harvell <jharvell+lists.linux-kernel@dogpad.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061230)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ACPI C and P states on Conroe
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to enable all the power saving features I can on my Conroe
E6600.  After much searching on the web, I am a little confused about
the Linux kernel support for ACPI on the Conroe.

Here is my setup:
Intel Core2 Duo E6600
Asus P5-B Deluxe board (Intel P965).
I am running a Gentoo kernel based on 2.6.19.4.

I have managed to enable EIST using cpufreq with the speedstep-centrino
driver.  But my understanding from browsing the ACPI spec is that this
is still within C0, i.e. not much power savings.

Here are my questions:

1) For P states, which cpufreq driver should I be using?  I've heard
speedstep-centrino is deprecated (but only some aspects of it) that are
being moved into acpi-cpufreq.  But I can't get acpi-cpufreq to load in
my kernel version.  Also, I would have thought speedstep-ich would be
the driver, just based on the name.  How do I know (other than trying
all modules to see which one loads) which one I should be using?
2) What kind of support for C1-C3 does the Conroe have?  The ACPI spec
says C2 and C3 require chipset support on the motherboard.  Does P965
have that.  Does it matter between boards (e.g. P5B)?
3) What versions of the kernel support C1-C3 states?  What kernel
options are germane to this?  What libraries/tools are involved?

---
Joe Harvell

