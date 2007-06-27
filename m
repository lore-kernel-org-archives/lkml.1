Return-Path: <linux-kernel-owner+w=401wt.eu-S1763155AbXF0VGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763155AbXF0VGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbXF0VGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:06:37 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33586 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXF0VGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:06:35 -0400
Message-ID: <4682D13C.6060107@novell.com>
Date: Wed, 27 Jun 2007 14:06:04 -0700
From: Crispin Cowan <crispin@novell.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 00/44] AppArmor security module overview
References: <20070626230756.519733902@suse.de> <20070626165202.bfe8e6df.akpm@linux-foundation.org> <20070627022403.GB14656@suse.de> <20070626194700.5b0ff477.akpm@linux-foundation.org> <20070627151114.GM1094@stusta.de>
In-Reply-To: <20070627151114.GM1094@stusta.de>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, Jun 26, 2007 at 07:47:00PM -0700, Andrew Morton wrote:
>   
>> Do you agree with the "irreconcilable" part?  I think I do. 
I am hoping for a reconciliation where the people who don't like
AppArmor live with it by not using it. AppArmor is not intended to
replace SELinux, it is intended to address a different set of goals.

>> I suspect that we're at the stage of having to decide between
>>
>> a) set aside the technical issues and grudgingly merge this stuff as a
>>    service to Suse and to their users (both of which entities are very
>>    important to us) and leave it all as an object lesson in
>>    how-not-to-develop-kernel-features.
>>
>>    Minimisation of the impact on the rest of the kernel is of course
>>    very important here.
>>
>> versus
>>
>> b) leave it out and require that Suse wear the permanent cost and
>>    quality impact of maintaining it out-of-tree.  It will still be an
>>    object lesson in how-not-to-develop-kernel-features.
>> ...    
> versus
>
> c) if [1] AppArmor is considered to be something that wouldn't 
>    be merged if it wasn't already widely deployed by Suse: leave it out, 
>    work on an ideal solution [2], and let Suse wear the one-time cost
>    of migrating their users to the ideal solution
>   
We argue that the proposed patch is a viable solution for providing
AppArmor functionality. We would be happy for specific suggestions on
how to make it better.

> I'm not claiming to understand the technical details, but from both 
> slightly reading over the previous discussions and the "What are the 
> advantages of AppArmor over SELinux?" section in the AppArmor FAQ [3] my 
> impression is that a main advantage of AppArmor are more user friendly 
> userspace tools. Therefore, if [1] AppArmor is considered technically 
> inferior to SELinux, it might still become more popular than SELinux 
> simply because it's easier to use - and although it's technically 
> inferior.  
AppArmor's advantages come from the model, not the tools. AppArmor is
not inferior to SELinux, it is different than SELinux. Neither can
replace the other without horrid kludges.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
Director of Software Engineering   http://novell.com
	AppArmor Chat: irc.oftc.net/#apparmor

