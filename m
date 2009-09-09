Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZIIRii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZIIRii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZIIRih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:38:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZIIRih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:38:37 -0400
Message-ID: <4AA7E82B.3080203@redhat.com>
Date: Wed, 09 Sep 2009 20:38:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Beth Kon <eak@us.ibm.com>, rostedt@goodmis.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Wierdness - linux-next KVM patch breaks Dell Latitude D820, KVM
 not in kernel
References: <3850.1252332427@turing-police.cc.vt.edu> <4AA65CFE.50402@us.ibm.com>            <22130.1252438888@turing-police.cc.vt.edu> <21211.1252517690@turing-police.cc.vt.edu>
In-Reply-To: <21211.1252517690@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 08:34 PM, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 08 Sep 2009 15:41:28 EDT, Valdis.Kletnieks@vt.edu said:
>
>    
>> Yeah, I was quite confused by the bisect results as well, I may end up
>> re-doing it just to make sure I didn't screw something up along the way (since
>> I started it with -rc7/HEAD as the good/bad, but most of the resulting
>> kernels reported a pre-rc7 release (a 2.6.28 at one point, IIRC, and it
>> finished at 31-rc2.
>>      
> I've become convinced that Something Really Bad happened to the KVM tree in
> linux-next on its way to my laptop - after 2 bisects, it reported I had some
> 2,000 commits left to check.  So I ran 'git bisect visualize' to sanity check.
>
> And *every single one* of those 4,000 commits between 'good' and 'bad' was a
> KVM commit, stretching all the way back to 2007.  Unless that's an artifact
> of the way linux-next is built, I would have expected only "new-ish" commits
> to be in the bisect window, and not just out of one tree...
>
> So I ended up doing a 'WTF?', an 'rm -r', and am cloning over today's linux-next
> and will see if that brings me any better joy.
>
>    

Oh, it's an artifact of kvm.git, not linux-next.  I really should feed 
something better to -next.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

