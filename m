Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKECYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKECYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYKECYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:24:15 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3369 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYKECYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:24:14 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=iI2QuBCXJOzDhVAuk2cA:9 a=jkZUZBsnOOjqBl7y5RJpKHxEKroA:4 a=j0CMlSstq6wA:10 a=eNxp2uuuQYoA:10
Message-ID: <491103CA.7090905@shaw.ca>
Date: Tue, 04 Nov 2008 20:24:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no> <fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no> <fa.8GbzH83c2CAI53n9dyzVOFugmoc@ifi.uio.no> <fa.hGdpNHQGmXAR19JiGuHxSr9N9CA@ifi.uio.no> <4910E6CD.9090605@mail.usask.ca> <49110093.5090506@rtr.ca>
In-Reply-To: <49110093.5090506@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Robert Hancock wrote:
>>
>> IDLE IMMEDIATE just transitions the device to the Idle state, which is 
>> normally parked/unloaded and spun down.
> ..
> 
> No, you're confusing "IDLE" with "STANDBY".  IDLE just puts the drive
> electronics into a lower-power state than "ACTIVE", but normally leaves
> the platters spinning.
> 
> The "UNLOAD" enhancement causes it to also "unload" or "park" (drive's 
> option)
> the heads as part of this action.
> 
> "STANDBY" is the command set which parks heads and spins down the platters.

Right, STANDBY IMMEDIATE was the one I was thinking of.
