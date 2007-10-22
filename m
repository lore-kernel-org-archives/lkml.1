Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbXJVNmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbXJVNmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXJVNmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:42:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:34755 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbXJVNmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:42:16 -0400
Message-ID: <471CA88B.7000706@qumranet.com>
Date: Mon, 22 Oct 2007 15:41:31 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bart Trojanowski <bart@jukie.net>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [BUG] 2.6.23.1 host freezes when running kvm
References: <20071019202019.GW3962@jukie.net> <20071020000240.GX3962@jukie.net> <20071020154445.GA5254@jukie.net> <471B366B.7040706@qumranet.com> <20071022132820.GA3962@jukie.net>
In-Reply-To: <20071022132820.GA3962@jukie.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski wrote:
> * Avi Kivity <avi@qumranet.com> [071021 07:23]:
>   
>> Does 2.6.23 hang immediately?  If so, these may be two separate problems 
>> and it's worth bisecting to find out what's the fix in 2.6.24-rc.
>>
>> Of course we'll have to address the later hang as well.
>>     
>
> Avi,
>
> it does not hang immediately.  It seems to wait until I go to bed to
> hang -- so it's going to be really fun to rebase.  It could be triggered
> by something that runs off cron in the guest or host.  I am not sure.  
>
> At this point I know that 2.6.23 and 2.6.24-rc0 hung, and 2.6.22.10
> (with kvm-userspace.git) ran overnight.
>
> I will try some of the 23-rc's next.
>   

I'm not sure that's useful -- very little changed after 2.6.23-rc1 (10 
patches).

There were 92 kvm patches in 2.6.23, so a bisect should take about a 
week worst case.


-- 
error compiling committee.c: too many arguments to function

