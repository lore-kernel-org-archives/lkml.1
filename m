Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbYFSOR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbYFSOR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYFSORV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:17:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbYFSORU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:17:20 -0400
Message-ID: <485A6A69.8090402@redhat.com>
Date: Thu, 19 Jun 2008 09:17:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
References: <4859F075.2050207@linux.intel.com> <485A668D.3050306@redhat.com> <485A680B.3020004@linux.intel.com>
In-Reply-To: <485A680B.3020004@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Eric Sandeen wrote:
>> Arjan van de Ven wrote:
>>> In the kerneloops.org stats, a new oops is rapidly climbing the charts.
>>> The oops is a page fault in the ext3 "do_slit" function, and the first
>>> report of it was with 2.6.26-rc6-git3.
>>>
>>> It happens with various applications; the backtraces are at:
>>>
>>> http://www.kerneloops.org/search.php?search=do_split
>> Arjan, I was just looking at kerneloops last night, seeing the count for
>> this oops climb, and was wishing there were some way to annotate an oops
>> signature with more info.  If I could have tagged this with the RH
>> bugzilla nr. it might have saved a lot of time for folks.  Is this
>> feasible?  Or is finding the oops text in bugzilla the only way?
>>
> 
> there's a way to add a description to oopses (you might have seen some of these
> descriptions already); however I've not implemented an account system yet so for
> now it's only me who can add these.

Ok, that was my guess.  I'll shoot you an email next time.  :)

Thanks,
-Eric
