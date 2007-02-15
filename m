Return-Path: <linux-kernel-owner+w=401wt.eu-S1161664AbXBOXIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161664AbXBOXIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161665AbXBOXIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:08:53 -0500
Received: from enzyme-e-109-1.chem.msu.ru ([212.192.240.75]:56200 "EHLO
	miclab.chem.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161664AbXBOXIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:08:52 -0500
X-Greylist: delayed 2040 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 18:08:52 EST
Message-ID: <45D4E000.6050403@miclab.chem.msu.ru>
Date: Fri, 16 Feb 2007 01:34:40 +0300
From: Ivan Babkin <ivan.babkin@miclab.chem.msu.ru>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Experimental driver for Ricoh Bay1Controller SD Card readers
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Apart from that I did the following changes:
> - implemented suspend/resume support (not tested very much)
> - named the registers
> - fixed a bug that caused a major slowdown when modprobed without debug=1
> - added writting support (disabled by default, modprobe with write=1)
> Before you enable writting please make sure that you did a proper backup of 
> the data on the card. Do not use this driver to save important data.
Thank for the job you've done!
Your driver works with 1 Gb sd-card (x86_64 suse's 2.16.18.2 kernel).
Read rate for me was around 250 Kb/s, write - 28 Kb/s (using dd utility).
BTW, I get continuous flow of "sdricoh_cs: timeout waiting for data"
messages in dmesg.

Good luck!
