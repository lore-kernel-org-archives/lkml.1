Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYGWVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYGWVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYGWVAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:00:09 -0400
Received: from dhcp-077-248-068-247.chello.nl ([77.248.68.247]:58881 "EHLO
	scorpion77.cjb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYGWVAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:00:07 -0400
X-Greylist: delayed 2411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 17:00:07 EDT
From: Jeroen Beerstra <jeroen@scorpion77.cjb.net>
To: Tejun Heo <tj@kernel.org>
Subject: Re: non functional pata dvd drive under 2.6.25.6
Date: Wed, 23 Jul 2008 22:19:47 +0200
User-Agent: KMail/1.9.9
References: <vi85j5-uig.ln1@scorpion77.cjb.net> <4880237A.7070002@kernel.org>
In-Reply-To: <4880237A.7070002@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807232219.47760.jeroen@scorpion77.cjb.net>
X-AntiVirus-By: Clam Antivirus 0.92.1
X-AntiSpam-By: Spamassassin 3.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

Op Friday 18 July 2008 07:00:42 schreef u:
> Hello, Jeroen.
>
> [cc'ing linux-ide]
>
> Hmmm... the problem could be caused by hald polling for media presence.
>  Does "hal-disable-polling /dev/srX" make any difference?
> hal-disable-polling setting is persistent so if your drive goes bonkers
> quickly after boot, you can disable polling, reboot and see whether
> anything is different.  Also, please post the result of "lspci -nn" and
> "hdparm -I /dev/srX" && please try 2.6.26.
>
> Thanks.

I'm pretty sure about that since the hald process I'm refering to points to 
the 'faulty' drive. However simply booting with noapic seems to fix all of my 
problems.

See:

Bug 451081 @ bugzilla.redhat.com
Bug 11044 @ bugzilla.kernel.org

regards,

Jeroen Beerstra


