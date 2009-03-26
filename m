Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZCZAdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZCZAdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZCZAda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:33:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZCZAd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:33:29 -0400
Message-ID: <49CACD0B.4060901@redhat.com>
Date: Wed, 25 Mar 2009 20:32:11 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bron Gondwana <brong@fastmail.fm>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <49C88C80.5010803@krogh.cc> <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090325234604.GA14828@brong.net>
In-Reply-To: <20090325234604.GA14828@brong.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bron Gondwana wrote:
> On Wed, Mar 25, 2009 at 04:23:08PM -0700, Linus Torvalds wrote:
>   
>> On Wed, 25 Mar 2009, Theodore Tso wrote:
>>     
>>>> The problem being that unlike the ratio, there's no sane default value 
>>>> that you can at least argue is not _entirely_ pointless.
>>>>         
>>> Well, if the maximum time that someone wants to wait for an fsync() to
>>> return is one second, and the RAID array can write 100MB/sec
>>>       
>> How are you going to tell the kernel that the RAID array can write 
>> 100MB/s?
>>
>> The kernel has no idea.
>>     
>
> Not at boot up, but after it's been using the RAID array for a little
> while it could...
>
> Bron (... imagining a tunable "max_fsync_wait_target_centisecs = 100" 
>       which caused the kernel to notice how long flushes were taking
>       and tune its buffer sizes to be approximately right over time )
>   
This tuning logic is the core of what Josef Bacik did for the 
transaction batching code for ext4....

ric

