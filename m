Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbXEKKkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbXEKKkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 06:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXEKKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 06:40:43 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4986 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760374AbXEKKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 06:40:41 -0400
Message-ID: <46444820.2020506@shadowen.org>
Date: Fri, 11 May 2007 11:40:32 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] update sysfs kset initialisation in PPC64 DLPAR IO	driver
References: <464322F3.3010808@shadowen.org>	 <2c705c055fcd12202673ee8a3056153b@pinky> <20070510141221.GA26709@suse.de>	 <46434041.7020903@shadowen.org>  <20070511071606.GB1211@suse.de> <1178870289.3923.6.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1178870289.3923.6.camel@concordia.ozlabs.ibm.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Fri, 2007-05-11 at 00:16 -0700, Greg KH wrote:
>> On Thu, May 10, 2007 at 04:54:41PM +0100, Andy Whitcroft wrote:
>>> Greg KH wrote:
>>>> On Thu, May 10, 2007 at 03:00:50PM +0100, Andy Whitcroft wrote:
>>>>> Move the rpadlpar device from "struct subsystem" to "struct kset"
>>>>> following the changes in sysfs.
>>>>>
>>>>> Signed-off-by: Andy Whitcroft <apw@shadowen.org>
>>>>> ---
>>>>>
>>>>> 	Ok, this patch seems to sort out the compile problem
>>>>> 	here and indeed boots and runs kernbench.  Perhaps
>>>>> 	you could confirm this is sufficient.
>>>> As per the discussion on the pci hotplug list, no, this doesn't seem to
>>>> fix the problem.  The developers there are looking into it.  If you can
>>>> test out patches for this, I'm sure the people there would appreciate
>>>> the help.
>>> Sure anything they have for testing, send them to me ...
>> They have the same patch that you made (I made it), yet they reported
>> that it didn't work properly for them.
>>
>> Can you test your patch out on "real" hardware?
> 
> I tested it on real hardware, but it can't hurt for Andy to try it too I
> guess.

To be fair I am not sure I have a clue how to test it.  Got a recipe?
My patch was based on how other drivers seemed to be converted which is
a concern for those drivers.

What sort of failure do you see?

-apw
