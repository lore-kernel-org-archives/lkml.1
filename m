Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbZBYLUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbZBYLUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761060AbZBYLTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:19:54 -0500
Received: from p-mail2.rd.francetelecom.com ([195.101.245.16]:4954 "EHLO
	p-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760846AbZBYLTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:19:54 -0500
Message-ID: <49A51B4D.5070903@Free.fr>
Date: Wed, 25 Feb 2009 11:19:57 +0100
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: airlied@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Some user feedback on recent Intel chipset and 2.6.29 KMS 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Feb 2009 10:19:40.0864 (UTC) FILETIME=[91E51C00:01C99732]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the nice work: for the first time (starting with
2.6.29-rc6-git1), I managed to remove the vesa framebuffer in favor of
intel's ones.  Recent X server (1.5.99.902 + git intel driver and git
drm) also comes up correctly and detects the KMS.

This amilo xi 3650 is a transportable SLI enabled laptop with Nvidia
GeForce 9600M GT & Mobile Intel® GM45 Express Chipset. By defaut the
Intel card is active. I can force using one or other in the bios but
expects one day I will be able to be able to dynamically switch like on
vista.

However there are still some problem with drm, Xorg, suspend/resume:

   1. The X server needs interrupts (mouse or keyboard) to redraw things
      (e.g if I do apt-get update in a konsole, I see it freeeze but if
      I move the mouse I get the complete output instantly. Same thing
      when I start a new application, I have to hit shift or move mouse.
      The same user land setting with 2.6.28.7 behaves correctly,
   2. I have a lot of problem with suspend to ram: when console comes up
      but with a cyan background and then X comes up completely garbled
      although I can distinguish some shadow of the windows and a
      konsole is still active if I enter init 0. Sometimes it purely
      freeze. If I switch back to tty (when I can), and restart kdm,
      then it starts only in 800x600 mode. Using krandrtray to put it
      back at 1920x1080, it simply freezes.

If I can help testing anything, providing traces (dmesg, config, lspci,
xorg config) let me know.

PS: CC me if anwering to the list I'm not suscribed.

-- eric
