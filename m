Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbYAHQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbYAHQ70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbYAHQ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:59:18 -0500
Received: from main.gmane.org ([80.91.229.2]:44825 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbYAHQ7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:59:17 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 16:59:06 +0000 (UTC)
Message-ID: <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, John Stoffel <john@stoffel.org> wrote:
> Look at your filesystems, using 'tune2fs' and see if the ext3 journal
> is actually turned on and used.  If it's not, then I can see why
> you're having problems on reboots.  

Journalling is on, but it's no use because the superblock always has
corrupted last-checked time at boot. "File system check forced: 31352
days since last check" or so. 

> What CPU are you using?  Chipset?  Output of lspci?  dmesg output?  

Athlon XP 2500+, SiI 3112 (the obsoleted driver that makes the disk 
appear as the predictable hde, not the random scsi mapping driver). 

As for the rest... I'm on Windows, because I can't be arsed waiting 
for an hour for Linux to boot.

-- 
Tuomo

