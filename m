Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYEZNGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYEZNGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYEZNGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:06:38 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:35953 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbYEZNGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:06:37 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 09:06:37 EDT
Message-ID: <483AB443.6020807@diamondcut.com.br>
Date: Mon, 26 May 2008 09:59:47 -0300
From: "Renato S. Yamane" <yamane@diamondcut.com.br>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Bug 10797] Something is consuming power after shutdown
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<http://bugzilla.kernel.org/show_bug.cgi?id=10797>
<http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=481493>

After poweroff, something still working and consuming power. So I loss 
~4% of my battery charge in each 12h.

If I shutdown my laptop using Kernel 2.6.24/25 when battery is 100%, 
after 12h my battery charge go to 96% (this information is checked with 
kpowersave and with LED available in my laptop that change color from 
blue to yellow when battery is not FULL).

If I shutdown this same laptop by WinXP (I have a dual boot), nothing 
change. So, my battery still have 100% after 12h (or more).

I see a similar problem in EeePC (the problem is with snd_hda_intel 
driver), but I don't have this driver loaded:
http://wiki.debian.org/DebianEeePC/HowTo/Troubleshooting#head-84d9d8a97c9ce198c59edd9cd93a05ab24fd1ff8

Best regards,
Renato S. Yamane
