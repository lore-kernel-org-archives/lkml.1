Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbXC1VJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbXC1VJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 17:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXC1VJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 17:09:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbXC1VJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 17:09:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=wJgy+Ph02zxhd2qK0jlSWmG97nE2mPytnVGk3lB7kCufqCAZkY9OPxyhD9y27eJoh
	Ln/Y8rr79W1zMFwdTD8fw==
Message-ID: <460AD940.8080507@google.com>
Date: Wed, 28 Mar 2007 14:08:16 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [FIXED] Re: tty OOPS (Re: 2.6.21-rc5-mm2)
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070328170214.GA13044@rhlx01.hs-esslingen.de> <20070328173310.GA4682@rhlx01.hs-esslingen.de> <20070328174524.GA25709@rhlx01.hs-esslingen.de> <20070328180446.GA7528@rhlx01.hs-esslingen.de> <20070328183814.GA5306@martell.zuzino.mipt.ru> <20070328185632.GB5306@martell.zuzino.mipt.ru> <20070328201511.GA20889@rhlx01.hs-esslingen.de>
In-Reply-To: <20070328201511.GA20889@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
>
> On Wed, Mar 28, 2007 at 10:56:32PM +0400, Alexey Dobriyan wrote:
>   
>> The only suspicious new patch in -rc5-mm1 to me is
>> fix-sysfs-reclaim-crash.patch which removes "sd->s_dentry = NULL;". Note
>> that whole sysfs_drop_dentry() is NOP if ->s_dentry is NULL.
>>
>> Could you try to revert it?
>>
>> 	Alexey, who knows very little about sysfs internals
>>     
>
> Apparently that's still too much knowledge ;)
>
> Or, in other words: 6 reboots already and not a single problem!
>
> So yes, the removal of the NULLing line in this patch most likely
> has caused this issue on my box.
> Now the question is whether something as simple as that is a fully
> correct fix or whether something should be done entirely differently.
> I'll let people more familiar with those parts decide about it...
>   

    Sorry -- I've only just been cc'd on this mail thread. Are we 
claiming that this patch/fix has caused a new problem, or successfully 
fixed an old problem?

    Thanks!
    -- Ethan

