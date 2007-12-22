Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbXLVWdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbXLVWdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXLVWdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:33:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbXLVWdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:33:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "werner" <werner@copaya.yi.org>
Subject: Re: Problems on booting
Date: Sat, 22 Dec 2007 23:52:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <1198354230.6569@copaya.yi.org>
In-Reply-To: <1198354230.6569@copaya.yi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712222352.26039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 of December 2007, werner wrote:
> There seems to have two regressions between the kernels from yesterday and before-yesterday
> On the kernel -git7 what didnt happened on -git6
> 
> 1) My hard disk is /dev/hda, but when I have an usb key sticked in /dev/sba,

I guess you mean /dev/sda?

> and run lilo then, then it dont boot but give L99 99 99 99 ... error.  When I
> remove the usb stick from /dev/sba , and run then #lilo ,  then the result
> boots.  This problem was not present at the -git6 kernel   
> 
> 2) The boot stops / hangs on hardware detection of SCSI.  I have an Initio
> INI-9X00U/UW. The last messages during boot are, that it's verifying i91u
> scsi2 , then the boot hangs.  When I put the pci=off kernel option, then the
> boot process continues (but with this, by other reasons, my computer works
> only half, so that this is unpracticable).      This problem also didnt
> happens with the -git6 kernel    This problem happens only on one of my two
> computers, because the other has no SCSI card inside, that computer boots
> normally.       

I have opened a bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=9621 and added it to the list of
reported regressions.

Thanks,
Rafael
