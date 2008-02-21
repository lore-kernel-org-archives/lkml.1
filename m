Return-Path: <linux-kernel-owner+w=401wt.eu-S934997AbYBUBRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934997AbYBUBRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760835AbYBUBRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:17:14 -0500
Received: from crca.org.au ([67.207.131.56]:46648 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762147AbYBUBRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:17:12 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47BCD112.3010708@nigel.suspend2.net>
Date: Thu, 21 Feb 2008 12:17:06 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@linux.ie>,
       linux-acpi@vger.kernel.org,
       suspend-devel List <suspend-devel@lists.sourceforge.net>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk.
 Screen becomes green.
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <200802201241.30952.jesse.barnes@intel.com> <alpine.LFD.1.00.0802201256040.7833@woody.linux-foundation.org> <200802201344.11643.jesse.barnes@intel.com> <47BCAD6E.9080704@nigel.suspend2.net> <20080221001357.GA29796@srcf.ucam.org> <47BCC866.9000102@nigel.suspend2.net> <20080221004632.GA25869@suse.de>
In-Reply-To: <20080221004632.GA25869@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Greg KH wrote:
> On Thu, Feb 21, 2008 at 11:40:06AM +1100, Nigel Cunningham wrote:
>> Hi.
>>
>> Matthew Garrett wrote:
>>> On Thu, Feb 21, 2008 at 09:45:02AM +1100, Nigel Cunningham wrote:
>>>> - people keep talking about hibernating to an ext3 fs mounted on fuse as 
>>>> a limitation of the freezer. To do that with kexec, you're still going to 
>>>> have to bmap the ext3 fs and pass the block list (in which case we can 
>>>> also do it without kexec) or umount all the ext3/fuse part and remount in 
>>>> the kexec'd kernel. Sort of defeats the purpose, doesn't it?
>>> No, with a freezer-based model you can basically *never* suspend to 
>>> anything related to FUSE or a userspace USB device or anything involving 
>>> userspace iSCSI initiators or whatever. Sure, there are cases where moving 
>>> away from the current model doesn't buy you anything, but that doesn't 
>>> mean that the current model is a good thing. It's not. The freezer is a 
>>> fundamentally broken concept.
>> Putting drivers and filesystems in userspace is the fundamentally broken 
>> concept. Not just when it comes to the freezer. The whole idea is 
>> inherently racy.
> 
> Racy with regards to other things becides trying to suspend a machine?
> If so, what?

That depends on what sort of tangled web you want to weave. Low memory 
situations is one other situation that occurs to me quickly, especially 
(though not only) if your ability to swap were to depend upon a 
userspace driver and/or filesystem.

Regards,

Nigel
