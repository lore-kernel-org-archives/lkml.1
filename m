Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZAGV3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZAGV3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZAGV3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:29:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:59190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZAGV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:29:14 -0500
Date: Wed, 7 Jan 2009 13:28:01 -0800
From: Greg KH <gregkh@suse.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, david-b@pacbell.net,
       khilman@deeprootsystems.com
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090107212801.GA21012@suse.de>
References: <20090107192438.GA18146@kroah.com> <49650F2C.9030809@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49650F2C.9030809@ru.mvista.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:23:08PM +0300, Sergei Shtylyov wrote:
> Hello.
>
> Greg KH wrote:
>
>> Here is the set of USB patches for the 2.6.29-rc1 merge.
>>
>> They also include the wimax patches, because of a dependancy on a change
>> in the USB core to support one of the wimax drivers.  The wimax patch
>> set has been acked by the network maintainers already, and they agreed
>> that it should go through the USB tree to you.
>>
>> Other than wimax, the patchset includes:
>> 	- some new USB drivers (gadget, host, and serial)
>> 	- USB OTG (on-the-go) device support
>> 	- lots of device id updates
>> 	- renaming in the i2c drivers to move into the proper location
>> 	  in the usb tree
>> 	- usb-storage quirk handling cleaned up and reworked
>> 	- sped up the option wireless usb driver speed.
>> 	- removal of info() and warn() usb macros now that the non-usb	  portions 
>> of the kernel have removed their usage of them.
>> 	- lots of minor tweaks and reworks.
>>
>> Please pull from:
>> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>>
>> All of these patches have been in the -next and -mm releases for a while.
>>
>> The full patches will be sent to the linux-usb mailing list, if anyone
>> wants to see them.
>>
>> thanks,
>>
>> greg k-h
>>   
>
> [...]
>
>> Kevin Hilman (1):
>>       USB: musb: build fixes for DaVinci
>>   
>
>   NAK this patch. I and David Brownell have asked Greg to pull this totally 
> broken patch (broken while in MUSB tree, the original patch was sane) from 
> his tree and all to no avail...
> The patch doesn't fix anything and only adds more breakage as it duplicates 
> musb_platform_set_mode().

{sigh}

I'll fix this up after Linus pulls, sorry about that.

>   I am dissatisfied how MUSB patches have been handled in general -- this 
> is not the first breakage, and the valid patches have been lost, so DaVinci 
> MUSB code keeps being broken since early 2.6.27-rc's (!) up to this time...

I agree, there's a big disconnect somewhere, I'm sorry about that.  I
now see David's request to change this patch in my archives :(

thanks,

greg k-h
