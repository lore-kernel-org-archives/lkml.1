Return-Path: <linux-kernel-owner+w=401wt.eu-S1751843AbXA0PDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbXA0PDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 10:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXA0PDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 10:03:30 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41177 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbXA0PDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 10:03:30 -0500
Message-ID: <45BB69BE.5060403@drzeus.cx>
Date: Sat, 27 Jan 2007 16:03:26 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: vandrove@vc.cvut.cz, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ncpfs and TCP vs UDP
References: <45BA2437.4000803@drzeus.cx> <1169846450.45ba70b2698c2@imap.vc.cvut.cz> <Pine.LNX.4.61.0701271550210.22295@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701271550210.22295@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Well, probably the same reason as NFS over UDP is discouraged. See nfs(5)
> section WARNINGS (in short: IP fragment ID can wrap quite fast on Gigabit)
>
>   

I have no such warning in my nfs(5), but I am aware of this yes.
Somewhat amusing that both nfs and ncpfs tend to default to using udp
with this in mind. ;)

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

