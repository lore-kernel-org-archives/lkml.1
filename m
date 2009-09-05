Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZIEKdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZIEKdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 06:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZIEKdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 06:33:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57074 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbZIEKdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 06:33:20 -0400
Date: Sat, 5 Sep 2009 12:28:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Rob Landley <rob@landley.net>, jim owens <jowens@hp.com>, david@lang.hm,
       Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
	document conditions when reliable operation is possible)
Message-ID: <20090905102810.GA1341@ucw.cz>
References: <20090826001645.GN4300@elf.ucw.cz> <200909022141.48827.rob@landley.net> <4A9FCF53.10105@hp.com> <200909040244.54772.rob@landley.net> <4AA0FECE.3010200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA0FECE.3010200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-09-04 07:49:34, Ric Wheeler wrote:
> On 09/04/2009 03:44 AM, Rob Landley wrote:
>> On Thursday 03 September 2009 09:14:43 jim owens wrote:
>>    
>>> Rob Landley wrote:
>>>      
>>>> I think he understands he was clueless too, that's why he investigated
>>>> the failure and wrote it up for posterity.
>>>>
>>>>        
>>>>> And Ric said do not stigmatize whole classes of A) devices, B) raid,
>>>>> and C) filesystems with "Pavel says...".
>>>>>          
>>>> I don't care what "Pavel says", so you can leave the ad hominem at the
>>>> door, thanks.
>>>>        
>>> See, this is exactly the problem we have with all the proposed
>>> documentation.  The reader (you) did not get what the writer (me)
>>> was trying to say.  That does not say either of us was wrong in
>>> what we thought was meant, simply that we did not communicate.
>>>      
>> That's why I've mostly stopped bothering with this thread.  I could respond to
>> Ric Wheeler's latest (what does write barriers have to do with whether or not
>> a multi-sector stripe is guaranteed to be atomically updated during a panic or
>> power failure?) but there's just no point.
>>    
>
> The point of that post was that the failure that you and Pavel both  
> attribute to RAID and journalled fs happens whenever the storage cannot  
> promise to do atomic writes of a logical FS block (prevent torn  
> pages/split writes/etc). I gave a specific example of why this happens  
> even with simple, single disk systems.

ext3 does not expect atomic write of 4K block, according to Ted. So
no, it is not broken on single disk.
 
>> The LWN article on the topic is out, and incomplete as it is I expect it's the
>> best documentation anybody will actually _read_.

Would anyone (probably privately?) share the lwn link?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
