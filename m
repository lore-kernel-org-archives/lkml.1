Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbZBYXAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbZBYXAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbZBYXAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:00:31 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52590 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZBYXAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:00:30 -0500
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 18:00:29 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=YelRoOjE6G+RKsvhhnrS9uIgXuCVLV1AZ7tZBiPL/qRTsX/UpsxZsmLM+psy7+mtz1
         NRiby/MaRhWM+UKDjLlc4Q0+LGcf+qfcc5b1Ni7O3D9BUrq5MUbFgN9U22JZZzJLwuuW
         cpSMs8S/fO1aP1BvG8f61mC1rg2GtamAVwjO8=
Message-ID: <49A5C8EA.6080205@gmail.com>
Date: Thu, 26 Feb 2009 00:40:42 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: 2.6.28.7: ATA errors after hibernation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more obstacle in my perpetual quest to have an empty /var/log/warn! :)

The following messages get logged after resuming from s2disk on my W500
Thinkpad running 2.6.28.7-pae. I do not notice any tangible ill effects
though:

Feb 25 09:30:59 linux-7vph kernel: Syncing filesystems ... done.
Feb 25 09:31:00 linux-7vph kernel: Freezing user space processes ...
(elapsed 0.00 seconds) done.
Feb 25 09:31:00 linux-7vph kernel: Freezing remaining freezable tasks
... (elapsed 0.00 seconds) done.
Feb 25 09:31:00 linux-7vph kernel: Suspending console(s) (use
no_console_suspend to debug)
Feb 25 09:31:06 linux-7vph vpnc[6025]: sendto: Invalid argument
Feb 25 09:31:09 linux-7vph kernel: Disabling non-boot CPUs ...
Feb 25 09:31:09 linux-7vph kernel: CPU1 is down
Feb 25 09:31:09 linux-7vph kernel: Enabling non-boot CPUs ...
Feb 25 09:31:09 linux-7vph kernel: CPU1 is up
Feb 25 09:31:09 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0
SErr 0x0 action 0x9 t4
Feb 25 09:31:09 linux-7vph kernel: ata1: irq_stat 0x00400040, connection
status changed
Feb 25 09:31:09 linux-7vph kernel: ata2: exception Emask 0x10 SAct 0x0
SErr 0x0 action 0x9 t4
Feb 25 09:31:09 linux-7vph kernel: ata2: irq_stat 0x40000001
Feb 25 09:31:09 linux-7vph kernel: Restarting tasks ... done.

Could these be linked to cases of human sleep deprivation or is this
joyful and harmless hardware chatter?

Niel
