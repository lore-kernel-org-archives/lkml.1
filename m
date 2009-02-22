Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbZBVP5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbZBVP5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 10:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbZBVP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 10:57:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:45113 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZBVP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 10:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QCejfWblkLBLzLggi0wMYykltcfH6WdX7MIo2j9Gw3LKv5rndtGH3DWikEN8H1Fm8G
         DgQQ85MdtO0gLS4Qb8F2IJleNXlB3He8z/Y7XuIb040MkzWPZWlLtsFUhmE39AxI1iG2
         rvmXSS8IY45ninZtS4LRHiXhHyj0gbLVo37bE=
Message-ID: <49A175E4.6070608@gmail.com>
Date: Sun, 22 Feb 2009 10:57:24 -0500
From: jacques <ocean4200@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: no sound with DIGITAL INPUT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a giga-byte GA-EG43-S2H with an integrated REALTEK ALC888 sound 
card. I'm unable to use the digital INPUT while recording or using pipe 
(arecord -M -D iec958 -f dat | aplay -D iec958 -f dat). Also, the 
giga-byte GA-EG41-S2H has the same problem (uses the same sound 
chipset). The giga-byte GA-EP45-UD3R is working perfectly but it uses a 
different sound chip (ALC889A). I tried a lot of things like changing 
snd-hda-intel model (auto, 6stack-dig, 3stack-dig, etc). I upgraded the 
ALSA sound driver to the latest version (1.0.19) and also used the 
snapshot. My distribution is Ubuntu 8.10 (server edition) 64 bits. I 
also installed the desktop version of it without success. I tested the 
digital input on Windows operating system and it works perfectly. Now, 
I'm not sure if I'm missing something with the configuration or it is a 
problem with the ALSA driver or the kernel module itself.

Look at the outputs from alsa-info script (computer outputs for details):
http://www.alsa-project.org/db/?f=068933737fa64bc43928b06d2f4b4559986e6439

Thank you for helping me to solve this problem.
