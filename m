Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYICMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYICMPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYICMPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:15:37 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:60277 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbYICMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:15:37 -0400
Message-ID: <48BE7FDF.3080202@fr.ibm.com>
Date: Wed, 03 Sep 2008 14:15:27 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <amirkin@parallels.com>
CC: devel@openvz.org, Oren Laadan <orenl@cs.columbia.edu>,
       containers@lists.linux-foundation.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, jeremy@goop.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [Devel] Re: [RFC v2][PATCH 4/9] Memory management - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <48BA454F.7050308@cs.columbia.edu> <48BAD637.2050505@fr.ibm.com> <200809031543.24001.amirkin@parallels.com>
In-Reply-To: <200809031543.24001.amirkin@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Mirkin wrote:
> On Sunday 31 August 2008 21:34 Cedric Le Goater wrote:
>> Oren Laadan wrote:
>>> Dave, Serge:
>>>
>>> I'm currently away so I must keep this short. I think we have so far
>>> more discussion than an actual problem. I'm happy to coordinate with
>>> every interested party to eventually see this work go into main stream.
>> thanks. We do need a moderator and federator.
>>
>>> My only concerns are twofold: first, to get more feedback I believe we
>>> need to get the code a bit more usable; including FDs is an excellent
>>> way to actually do that. That will add significant value to the patch.
>> hmm, yes and no.
>>
>> fd's are a must have but I would be more interested to see an external
>> checkpoint/restart and signal support first. why ? because it would be
>> already usable for most computational programs in HPC, like this stupid
>> one :
>>
>> 	https://www.ccs.uky.edu/~bmadhu/pi/pi1.c
>>
>> signals are required because it's how 'load' and/or 'system' managers
>> interact with the jobs they spawn. external checkpoint/restart for the
>> same reason.
> 
> I'm sorry for being out of discussion for so long time.
> I've just sent a patchset with external checkpoint/restart as it is 
> implemented in OpenVZ.
> External checkpoint/restart also is very usefull if we will have container's 
> infrastructure in mainstream.
> It won't be very hard to add support for signals in my patchset. I'll wait for 
> some time for comments and will add support for signals in next version.

OK.

Then, we should be able to have a simple C/R framework (user and kernel) if we
integrate your patchset or Oren's with Daniel's user tools :

	http://lxc.cvs.sourceforge.net/lxc/

I was just starting to work on Oren's patchset when you sent yours :) 

Thanks,

C.
