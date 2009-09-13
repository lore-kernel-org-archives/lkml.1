Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZIMLkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZIMLkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 07:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZIMLkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 07:40:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZIMLkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 07:40:03 -0400
Message-ID: <4AACD9F1.4000908@redhat.com>
Date: Sun, 13 Sep 2009 14:39:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Beth Kon <eak@us.ibm.com>, rostedt@goodmis.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM
 not in kernel
References: <3850.1252332427@turing-police.cc.vt.edu> <4AA65CFE.50402@us.ibm.com> <22130.1252438888@turing-police.cc.vt.edu> <21211.1252517690@turing-police.cc.vt.edu> <4AA7E82B.3080203@redhat.com>            <25165.1252522752@turing-police.cc.vt.edu> <125228.1252788933@turing-police.cc.vt.edu>
In-Reply-To: <125228.1252788933@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2009 11:55 PM, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 09 Sep 2009 14:59:12 EDT, Valdis.Kletnieks@vt.edu said:
>
>    
>> So hopefully excluding kvm.git I'll track down the *original* hang...
>>
>> Wish me luck. ;)
>>      
> And luck was not to be had.  Apparently 'git bisect skip' has some bad O(n**2)
> issues - I tried to exclude the kvm.git tree, and it ended up running literally
> overnight with no signs of stopping (see the gory details here:
> https://bugzilla.redhat.com/show_bug.cgi?id=522599 )  Now, I probably *could*
> cobble up something to do the skip as a series of little 20-40 commit skips,
> but that's just getting nuts. ;)
>
> Given that I'm having little luck bisecting this issue in linux-next and
> we're now into the merge window, does anybody have a *better* idea than letting
> the issue get into Linus's tree around -rc1, and hope that bisects more nicely
> than linux-next did, so -rc2 has a fix for it?
>    

Current linux-next should now be easily bisectable without the kvm.git 
issues you encountered.

-- 
error compiling committee.c: too many arguments to function

