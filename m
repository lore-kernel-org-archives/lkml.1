Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYAFN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYAFN7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 08:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYAFN7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 08:59:12 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:50341
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYAFN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 08:59:10 -0500
Date: Sun, 6 Jan 2008 07:05:36 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Sam Ravnborg <sam@ravnborg.org>, Al Boldi <a1426z@gawab.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage	support
In-Reply-To: <4780DA92.6050403@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0801060652390.16883@asgard.lang.hm>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com>
 <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org>
 <47801126.7020807@oracle.com> <20080105234540.GG22232@does.not.exist>
 <47802249.9010107@s5r6.in-berlin.de> <20080106005807.GH22232@does.not.exist>
 <4780C728.1030806@s5r6.in-berlin.de> <20080106123728.GD2082@does.not.exist>
 <4780D3E5.20908@s5r6.in-berlin.de> <Pine.LNX.4.64.0801060643370.16883@asgard.lang.hm>
 <4780DA92.6050403@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008, Stefan Richter wrote:

> David Lang wrote:
>> On Sun, 6 Jan 2008, Stefan Richter wrote:
>>> Module autoloading is quite different.
>>
>> but if boot scripts can figure out what modules to autoload, why can't
>> scripts be written to figure out what drives to build into a system?
>
> Because build-time configuration has to deal with different, more
> complex questions than run-time configuration.  For starters, build-time
> configuration narrows down the options for run-time configuration.

Ok, I'll bite.

what config options must be selected by the user at build time? (i.e. no 
sane default can possibly be deduced from the hardware)

there are a lot of options that, if selected, will affect the final result 
significantly. but I can't think of any that can't have a reasonable 
default.

what sysadmins like me would really like is a set of scripts that could 
generate a .config from an existing system. After we have one that covers 
the hardware for the system we will then have a much better starting point 
to work from. We may disable some drivers (sound drivers on a server for 
example). We may enable other drivers (or combine the results of runs on 
seperate hardware to make a slightly more general kernel config). And we 
will make many other selections that are not hardware dependant (SLAB vs 
SLUB vs SLOB, IO schedulers, etc) but just figuring out what drivers are 
needed to support a particular piece of hardware would be a huge help. 
It's frequently hard to figure out which drivers are needed for a Vendor X 
model 12345 motherboard (major things are easy, it gets hard when you want 
to do power monitoring and things like that) it is even harder when you 
have to figure out what needs to be enabled so that you can see the help 
text of other options to see if they are the right ones.

I started toying with Linux (on my home systems) in the 0.99 days and have 
been makeing my living with it starting in the 1.3 days, so it's not that 
I am a newcomer to kernel configuration, but even with my experiance it's 
sometimes hard to figure out what I need to enable when I start needing a 
new set of functionality on a system.

David Lang
