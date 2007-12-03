Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXLCVbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXLCVbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXLCVbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:31:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43431 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbXLCVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:31:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Warpme <warpme@o2.pl>
Subject: Re: S3 resume stability problems
Date: Mon, 3 Dec 2007 22:50:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux kernel <linux-kernel@vger.kernel.org>
References: <475460EA.4050606@o2.pl>
In-Reply-To: <475460EA.4050606@o2.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712032250.17915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of December 2007, Warpme wrote:
> Hi *
> 
> I'm setting up 2 appliances based on AMD x2 4400 CPU and Nvidia Mobos: 
> ASUS M2NPV-VM (6150 based) and Abit AN-M2HD (7050 based). Kernel is 
> 2.6.23.9.
> 
> My issue is stability of S3 resume:
> -on ASUS it hangs every 3-10 try and it not depends on maxcpus setting.
> -on Abit also it hangs every 3-10 try, but with maxcpus=1 is stable.
> 
> It is not depending on enabled HW on mobos - even with all HW disabled 
> in BIOS S3, resume is still unstable.
> 
> Observing resume process I didn't see any errors in syslog. Also when 
> resume hangs it hangs always with still lightning CapsLock keyb led 
> (keyb is not reacting on CapsLock pressing) -> it leads me that it isn't 
> video issue.
> 
> As Abit with maxcpus=1 is working OK - it hints me that resume issue is 
> related to non-booting processor initialization.
> 
> Do somebody can help me investigate problem ?

Please file a bug report at
http://bugzilla.kernel.org/enter_bug.cgi?product=Power%20Management
against the Hibernation/Suspend component and add my address to the report's
CC list.

Thanks,
Rafael
