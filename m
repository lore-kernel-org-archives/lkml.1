Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbXKBRKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbXKBRKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbXKBRJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:09:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239AbXKBRJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:09:53 -0400
Message-ID: <472B59CC.9030206@redhat.com>
Date: Fri, 02 Nov 2007 13:09:32 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       duaneg@dghda.com, npiggin@suse.de
Subject: Re: patch	remove-broken-ptrace-special-case-code-from-file-mapping.patch
 queued to -stable tree
References: <20071102162222.EC46D14540CB@imap.suse.de> <alpine.LFD.0.999.0711020945330.3342@woody.linux-foundation.org> <20071102165816.GA16493@suse.de>
In-Reply-To: <20071102165816.GA16493@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2007 12:58 PM, Greg KH wrote:
> On Fri, Nov 02, 2007 at 09:48:34AM -0700, Linus Torvalds wrote:
>>
>> On Fri, 2 Nov 2007, gregkh@suse.de wrote:
>>> This is a note to let you know that we have just queued up the patch titled
>>>
>>>      Subject: Remove broken ptrace() special-case code from file mapping
>> Hmm. I think my patch is good, but Nick's patch is probably safer for a 
>> stable release.
>>
>> Mine cleans things up, and removes a rather nasty special case entirely. 
>> But in the process, it changes user-visible behaviour (for the better, I 
>> think, but still).
>>
>> Now, probably nobody cares about the behaviour change, but Nicks patch 
>> fixes the old broken special case instead of removing it.
>>
>> Now, it might be perfectly fine to just queue this one on the assumption 
>> that nobody will really care, and doing a cleanup is better. But I wanted 
>> to point out the (small) danger.
> 
> I don't see Nick's patch in your tree, and I'd like to keep in sync
> wherever possible :)
> 
> Unless Nick really objects, and then I'll drop yours and use his, but I
> don't think that Duane verified that his patch fixed the issue.
> 

I put Nick's in Fedora, so it had better work...  ;)

