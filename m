Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYLaRmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYLaRmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYLaRlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:41:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:23193 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbYLaRlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:41:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ibo3egqhJqX3zfSnKymUsul3Ky0cA0mYIoPqZO/8RiwgpyzTdSjld8z7DtSo9Z8gKX
         zY0VSWwLt24IJ9bdWq5znBxNTrsH4VI6zluBlUGC4ZNAf7I4kVjL24V/TrX+iYHn1CVE
         uRlAF/xUfPI64OKmbivYl0wRSymYE2OF+KGEY=
Message-ID: <495BAED9.3000305@gmail.com>
Date: Wed, 31 Dec 2008 09:41:45 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Martin Steigerwald <martin.steigerwald@googlemail.com>
CC: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
       sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
References: <200812301935.49303.phillips@phunq.net> <200812310000.55256.phillips@phunq.net> <495B2A02.5010701@gmail.com> (sfid-20081231_102522_624170_EF6300E3) <200812311109.12635.Martin@lichtvoll.de>
In-Reply-To: <200812311109.12635.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Am Mittwoch 31 Dezember 2008 schrieb Justin P. Mattock:
>   
>> Daniel Phillips wrote:
>>     
>>> On Tuesday 30 December 2008 23:34, sniper wrote:
>>>       
>>>> Great, I have mounted tux3 filesystem under UML with stuffs in this
>>>> mail, but I still can't debug it with gdb. Anyone gives me
>>>> suggestion?
>>>>         
>>> You just have to give a "cont" command a bunch of times and you will
>>> eventually get to a command prompt.  The reason for this is, uml uses
>>> the segfault interrupt as part of its machine simulation, and there
>>> is no exsiting way for uml and gdb to communicate in such a way that
>>> uml can recognize that the interrupt came from its own code and
>>> filter it.
>>>       
>
> [...]
>
>   
>> Hmm.. seems like a redundancy;
>> Anyways I looked at you're site, but am still
>> confused at what tux3 is: what is tux3?
>>
>> (at first I thought it was  a  video game, but was wrong);
>> can I use tux3 to secure a linux system or is it for
>> something else?
>>
>>     
>
> Hmmm, I thought
>
> ---------------------------------------------------------------------
> Tux3 is a write-anywhere, atomic commit, btree-based versioning 
> filesystem. It is the spiritual and moral successor of Tux2, the most 
> famous filesystem that was never released. The main purpose of Tux3 is to 
> embody Daniel Phillips's new ideas on storage data versioning. The 
> secondary goal is to provide a more efficient snapshotting and 
> replication method for the Zumastor NAS project, and a tertiary goal is 
> to be better than ZFS.
> ---------------------------------------------------------------------
> http://tux3.org/
>
> was pretty clear. What are you missing?
>
> Ciao,
>   

I guess this is what is confusing to me:
atomic commit, btree-based versioning.

irregardless about how it's worded,
I'm wondering if I should use this mechanism,
or not. 
 
regards;

Justin P. Mattock

