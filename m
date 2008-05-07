Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYEGFha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYEGFha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYEGFhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:37:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37725 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYEGFhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:37:11 -0400
Message-ID: <48214007.7050800@bull.net>
Date: Wed, 07 May 2008 07:37:11 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, cmm@us.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
References: <20080211141646.948191000@bull.net>	<20080211141813.354484000@bull.net>	<12c511ca0804291328v2f0b87csd0f2cf3accc6ad00@mail.gmail.com>	<481EC917.6070808@bull.net>	<1FE6DD409037234FAB833C420AA843EC014392F9@orsmsx424.amr.corp.intel.com> <20080506180527.GA8315@sergelap.austin.ibm.com>
In-Reply-To: <20080506180527.GA8315@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Luck, Tony (tony.luck@intel.com):
> 
>>>Well, this printk had been suggested by somebody (sorry I don't remember 
>>>who) when I first submitted the patch. Actually I think it might be 
>>>useful for a sysadmin to be aware of a change in the msgmni value: we 
>>>have the message not only at boot time, but also each time msgmni is 
>>>recomputed because of a change in the amount of memory.
>>
>>If the message is directed at the system administrator, then it would
>>be nice if there were some more meaningful way to show the namespace
>>that is affected than just printing the hex address of the kernel structure.
>>
>>As the sysadmin for my test systems, printing the hex address is mildly
>>annoying ... I now have to add a new case to my scripts that look at
>>dmesg output for unusual activity.
>>
>>Is there some better "name for a namespace" than the address? Perhaps
>>the process id of the process that instantiated the namespace???
> 
> 
> I agree with Tony here.  Aside from the nuisance it is to see that
> message on console every time I unshare a namespace, a printk doesn't
> seem like the right way to output the info.

But you agree that this is happening only because you're doing tests 
related to namespaces, right?
I don't think that in a "standard" configuration this will happen very 
frequently, but may be I'm wrong.

>  At most I'd say an audit
> message.
> 

That's a good idea. Thanks, Serge. I'll do that.

Regards,
Nadia

