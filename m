Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYBMM4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYBMM4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYBMM4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:56:25 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:35846 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYBMM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:56:23 -0500
Message-ID: <47B2E931.4080408@keyaccess.nl>
Date: Wed, 13 Feb 2008 13:57:21 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: bzolnier@gmail.com, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: "ide=reverse" do we still need this?
References: <20080213001506.GA13933@kroah.com> <47B24AB3.3040009@keyaccess.nl> <20080213044436.GB10101@kroah.com> <47B2DD45.7080709@keyaccess.nl>
In-Reply-To: <47B2DD45.7080709@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-08 13:06, Rene Herman wrote:
> On 13-02-08 05:44, Greg KH wrote:
> 
>>> While details escape me somewhat again at the monment, a few months ago
>>> I was playing around with a PCI Promise IDE controller and needed
>>> ide=reverse to save me from having to switch disks around to still have
>>> a bootable system.
>>>
>>> Or some such. Not too clear anymore, but I remember it saved the day.
>>
>> You couldn't just change the boot disk in grub?
>>
>> Or use an initramfs and /dev/disk/by-id/ to keep any future moves stable?
> 
> No. The thing is that you need these kinds of hacks while messing with 
> old systems, building and stripping them, often in recovery type of 
> situations.
> 
> As said (same as the other person I saw reacting) details of what was 
> most decidedly needed last time around escape me at the moment, but 
> ide=reverse is the kind of hack that saves one hours of unscrewing 
> computer cases and switching disks around while building stuff, making 
> quick tests, doing recovery...
> 
> If it must go for the greater architectural good, so be it, but it's the 
> type of thing that's used specifically in the situations where you don't 
> have stable, well arranged (or known!) setups to begin with.

Allow me to add that the demise of drivers/ide itself is an argument for 
just shooting the thing if it helps clean up the API. Next year when I'm 
messing with that Promise controller again, the machine might very well be 
running a kernel using PATA instead of IDE anyway...

Rene.

