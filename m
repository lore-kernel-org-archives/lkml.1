Return-Path: <linux-kernel-owner+w=401wt.eu-S1762082AbXKPP2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762082AbXKPP2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXKPP2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:28:30 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:34143 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbXKPP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:28:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=MfQlOrv/m42pCe1WVsJKrt4KfcDsFWFEK0ZDKJzm7bAzq20gkLbQb88pXjgO8Ef14lvs4k5JY0v3EDJ0qwemf95gRMV+ZBH9UKewVpJgot2erM3ZEiuSfb/KAXMq9oOpMCy/tjObIuJWxeexmYCxOgrmStVuQ06xJ2gX/XdedjM=
Date: Fri, 16 Nov 2007 23:26:21 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Greg KH <greg@kroah.com>,
       Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken
	in 2.6.23.1)
Message-ID: <20071116152621.GC2463@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200711032351.52977.rob@landley.net> <200711142358.16072.rob@landley.net> <20071115060255.GA4837@kroah.com> <200711151457.22395.rob@landley.net> <20071115210608.GA12213@kroah.com> <20071116030832.GB2563@hacking> <20071116151257.GA5291@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116151257.GA5291@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 10:12:57AM -0500, Jeff Dike wrote:
>On Fri, Nov 16, 2007 at 11:08:32AM +0800, WANG Cong wrote:
>> Could you please try this patch? Can it fix the error?
>> 
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>> 
>> ---
>> 
>> diff --git a/Makefile b/Makefile
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 4f3838a..2c3ce4c 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -6,6 +6,7 @@
>>  #include <linux/mmzone.h>
>>  #include <linux/list.h>
>>  #include <linux/sched.h>
>> +#include <linux/pagemap.h>
>>  
>>  #include <asm/atomic.h>
>>  #include <asm/page.h>
>
>If you look further down the file, you see a comment to the effect that this
>will break sparc.
>

Sorry, I didn't know that. ;(

