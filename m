Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbZABUhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbZABUhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbZABUgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:36:43 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:45360 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZABUgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LgM5kbBKtJilBg0KZ1iwB12fJylywyS1wrwuL7orj5ijJRpfbQknHpgQ6XS60ofk4J
         eBs3dwdAqQ0u0h0K+Ml6mtX+g2ngeNTh5GH3ELbIOhZtGVOXiphMWsVYhXq/3UU70kms
         rQl5e6QigtSrNXpwv2soo4sEwj4x59g53vIYM=
Message-ID: <495E7AD2.3000405@gmail.com>
Date: Fri, 02 Jan 2009 12:36:34 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Martin Steigerwald <Martin@Lichtvoll.de>
CC: tux3@tux3.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Phillips <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <200812311109.12635.Martin@lichtvoll.de> <495BAED9.3000305@gmail.com> (sfid-20090102_152147_492889_6D60D0EE) <200901022117.24504.Martin@Lichtvoll.de>
In-Reply-To: <200901022117.24504.Martin@Lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
>   
>> Martin Steigerwald wrote:
>>     
>>> Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
>>>       
>>>> Daniel Phillips wrote:
>>>>         
>>>>> On Tuesday 30 December 2008 23:34, sniper wrote:
>>>>>           
>>>>>> Great, I have mounted tux3 filesystem under UML with stuffs in
>>>>>> this mail, but I still can't debug it with gdb. Anyone gives me
>>>>>> suggestion?
>>>>>>             
>>>>> You just have to give a "cont" command a bunch of times and you
>>>>> will eventually get to a command prompt.  The reason for this is,
>>>>> uml uses the segfault interrupt as part of its machine simulation,
>>>>> and there is no exsiting way for uml and gdb to communicate in such
>>>>> a way that uml can recognize that the interrupt came from its own
>>>>> code and filter it.
>>>>>           
>>> [...]
>>>
>>>       
>>>> Hmm.. seems like a redundancy;
>>>> Anyways I looked at you're site, but am still
>>>> confused at what tux3 is: what is tux3?
>>>>
>>>> (at first I thought it was  a  video game, but was wrong);
>>>> can I use tux3 to secure a linux system or is it for
>>>> something else?
>>>>         
>>> Hmmm, I thought
>>>
>>> ---------------------------------------------------------------------
>>> Tux3 is a write-anywhere, atomic commit, btree-based versioning
>>> filesystem. It is the spiritual and moral successor of Tux2, the most
>>> famous filesystem that was never released. The main purpose of Tux3
>>> is to embody Daniel Phillips's new ideas on storage data versioning.
>>> The secondary goal is to provide a more efficient snapshotting and
>>> replication method for the Zumastor NAS project, and a tertiary goal
>>> is to be better than ZFS.
>>> ---------------------------------------------------------------------
>>> http://tux3.org/
>>>
>>> was pretty clear. What are you missing?
>>>
>>> Ciao,
>>>       
>> I guess this is what is confusing to me:
>> atomic commit, btree-based versioning.
>>     
>
> Ah, the buzz words. ;)
>
> The tux3 mailing list contains quite some design notes about these 
> concepts. I think others can give better answers about these concepts - I 
> think I understood what it is for, not the implementation details. But 
> basically "atomic commit" is a strategy to have the filesystem always in 
> a consistent state and btree-based versioning allows to keep different 
> versions of a file / directory around. And unlike other filesystem tux3 
> has this per inode and not for the complete filesystem. At least if I 
> understand correctly.
>
> But at least it should clear that tux3 is a filesystem and not a video 
> game ;).
>
>   
>> irregardless about how it's worded,
>> I'm wondering if I should use this mechanism,
>> or not.
>>     
>
> Right now its still in heavy development and not of release quality. I.e. 
> something to play around and test with if you want. 
>
> Ciao,
>   
Yeah, my bad for thinking tux3 was a video game
(don't ask why); I need to get glasses!!
When I was told it was a filesystem it clicked.
As for the atomic commit Thanks for explanation.
(I honestly had no idea what that meant);
with test and playing around with this, I have
an old dell inspiron hanging around, when
I have the time I'll have to give it a try.
Do I have to wipe out the ext3 partition
on it, or is that O.K.

regards;

Justin P. Mattock

