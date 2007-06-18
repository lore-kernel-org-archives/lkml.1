Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXFRWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXFRWrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbXFRWr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:47:28 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:50822 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764399AbXFRWr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:47:27 -0400
Date: Mon, 18 Jun 2007 15:47:26 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
In-Reply-To: <4676F9A2.6010007@zytor.com>
Message-ID: <Pine.LNX.4.64.0706181545100.25913@blackbox.fnordora.org>
References: <8wst3-3kh-31@gated-at.bofh.it> <8wsCC-3wf-21@gated-at.bofh.it>
 <8wsW4-3UY-3@gated-at.bofh.it> <8wJal-3KA-1@gated-at.bofh.it>
 <8xm22-4Ql-1@gated-at.bofh.it> <8xq5G-32l-7@gated-at.bofh.it>
 <8xs7w-69W-21@gated-at.bofh.it> <E1I0OFQ-0001B9-7Z@be1.lrz>
 <Pine.LNX.4.64.0706181406250.25913@blackbox.fnordora.org> <4676F9A2.6010007@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, H. Peter Anvin wrote:

> alan wrote:
>> On Mon, 18 Jun 2007, Bodo Eggert wrote:
>>
>>> alan <alan@clueserver.org> wrote:
>>>
>>>> I just wish that people would learn from the mistakes of others.  The
>>>> MacOS is a prime example of why you do not want to use a forked
>>>> filesystem, yet some people still seem to think it is a good idea.
>>>> (Forked filesystems tend to be fragile and do not play well with
>>>> non-forked filesystems.)
>>>
>>> What's the conceptual difference between forks and extended user
>>> attributes?
>>
>> Forks tend to contain more than just extended attributes.  They contain
>> all sorts of other meta-data including icons, descriptions, author
>> information, copyright data, and whatever else can be shoveled into them
>> by the author/user.
>
> And that makes them different from extended attributes, how?

The amount of crap.  Both seem to become a collection bin for "stuff we 
need to describe this object".  Forks seem to get more piled on, but they 
are effectively the same thing.

> Both of these really are nothing but ad hocky syntactic sugar for
> directories, sometimes combined with in-filesystem support for small
> data items.

And both tend to break when you go to a file system that does not support 
them.

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
