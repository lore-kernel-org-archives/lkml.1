Return-Path: <linux-kernel-owner+w=401wt.eu-S934641AbYEBN4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934641AbYEBN4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762207AbYEBN42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:56:28 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:52911 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbYEBN41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:56:27 -0400
Message-ID: <481B1A7D.2020000@aitel.hist.no>
Date: Fri, 02 May 2008 15:43:25 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kasper Sandberg <lkml@metanurb.dk>
CC: David Rees <drees76@gmail.com>, David Lethe <david@santools.com>,
       alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs
References: <1209692359.16523.2.camel@localhost>	 <73000.21239.qm@web50212.mail.re2.yahoo.com>	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>	 <1209696179.16523.13.camel@localhost>	 <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com> <1209715763.7827.2.camel@localhost>
In-Reply-To: <1209715763.7827.2.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kasper Sandberg wrote:
> On Fri, 2008-05-02 at 00:06 -0700, David Rees wrote:
>   
>> On Thu, May 1, 2008 at 7:42 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
>>     
>>>  in other words, would i be
>>>  safer to run rsync every day to my other disk, and run in non-raid
>>>  mode?!
>>>       
>> What would be safer is to run rsync every day from one redundant array
>> to another array - preferably on another machine that is located as
>> far away as possible from the one that you are backing up.
>>
>> RAID is not the same as a backup, though unfortunately, too many
>> people treat it as such.
>>     
> Im not treating it as a backup, what i want, is to make sure that if 1
> disk dies, the data is still intact and ill hopefully be able to run
> with 1 disk till the newly ordered one arrives - and while i naturally
> will keep offsite backups of most important data, it is certainly far
> easier to simply rip out a faulty disk, and put in another, instead of
> restoring from backup from scratch..
>
> So my question remains.. Is md raid1 not suited for this need? would it
> be safer to run in non-raid1 mode and daily(maybe hourly) rsync
> everything over to the second disk?
>   
Raid protects against disk failure. So your use  is fine.

Backup also protects against user error and virus/worm/cracker damage.
If you accidentally overwrite a file, or a virus/worm/cracker messes up 
the filesystem,
then RAID loose because the overwiting/messing happens on both disks.
In that case you'll still be able to get stuff from a backup.


Helge Hafting
