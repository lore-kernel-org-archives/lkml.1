Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbYJZLzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbYJZLzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYJZLyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:54:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:37073 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYJZLyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=i78iqvm/n6roa03Ovk5V3Ej1zqrjcCGlqzoqnTbTMyrBQiimXQ6mwnPn08Rgil1ATl
         1ugQbkY5SzMjGc7IiAwrvSIDfI15mOu0u3ZiiKNIpCBfuxiqOg0KvR7qdC1CAD65H+ZG
         oMYY2yzz3impRpDzYyvvQNCu/P4NV9PoNdMgs=
Message-ID: <49045A88.2010508@gmail.com>
Date: Sun, 26 Oct 2008 12:54:48 +0100
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080927)
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Random problems with 2.6.28-rc1-git1
References: <490332E5.3020108@gmail.com> <Pine.LNX.4.64.0810260235490.22126@twin.jikos.cz> <49041B73.8060603@gmail.com> <200810261231.02764.andres@anarazel.de>
In-Reply-To: <200810261231.02764.andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Freund ha scritto:
> Hi,
>
> On Sunday 26 October 2008 08:25:39 Mikko C. wrote:
>   
>>> If rmmod never returns, alt-sysrq-t output should show us where it got
>>> stuck.
>>>       
>> Thanks for your answer
>> I tried Alt-Sysrq-T after a rmmod, but all I get is:
>> "SysRq : Show State"
>> Is it normal? Does it dump the information to a log?
>> Sorry but I never used sysrq in the past.
>>     
> You propably have to set the loglevel to something higher before. Either use 
> dmesg -n 6 or so or sysrq-6.
>
> Andres
>   
Ok, got it.

Oct 26 12:39:56 gentoo rmmod         D ffffffff80532a80     0  5264   5088
Oct 26 12:39:56 gentoo ffff880079b5bd78 0000000000000082 
0000000000000000 ffff880079b5bd3c
Oct 26 12:39:56 gentoo ffffffff806d3000 ffff88007fafb600 
ffff88007f863000 ffff88007fafb850
Oct 26 12:39:56 gentoo 00000001895a50c0 00000000fffe90e8 
ffff88007fafb850 00000000000160d1
Oct 26 12:39:56 gentoo Call Trace:
Oct 26 12:39:56 gentoo [<ffffffff8052332d>] schedule_timeout+0xad/0xf0
Oct 26 12:39:56 gentoo [<ffffffff80522578>] wait_for_common+0x148/0x170
Oct 26 12:39:56 gentoo [<ffffffff80231770>] default_wake_function+0x0/0x10
Oct 26 12:39:56 gentoo [<ffffffff8022da33>] __wake_up+0x43/0x70
Oct 26 12:39:56 gentoo [<ffffffff8024a464>] flush_cpu_workqueue+0x44/0x90
Oct 26 12:39:56 gentoo [<ffffffff8024a690>] wq_barrier_func+0x0/0x10
Oct 26 12:39:56 gentoo [<ffffffff8025e150>] __try_stop_module+0x0/0x30
Oct 26 12:39:56 gentoo [<ffffffff8024a5cb>] flush_workqueue+0x3b/0x60
Oct 26 12:39:56 gentoo [<ffffffff8025e150>] __try_stop_module+0x0/0x30
Oct 26 12:39:56 gentoo [<ffffffff8026997c>] __stop_machine+0x10c/0x130
Oct 26 12:39:56 gentoo [<ffffffff80261ced>] sys_delete_module+0x17d/0x290
Oct 26 12:39:56 gentoo [<ffffffff80288c68>] do_munmap+0x348/0x390
Oct 26 12:39:56 gentoo [<ffffffff803a0d51>] __up_write+0x21/0x150
Oct 26 12:39:56 gentoo [<ffffffff8020b94b>] system_call_fastpath+0x16/0x1b

Let me know if it's enough.
Thanks
