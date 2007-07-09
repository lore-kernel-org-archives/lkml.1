Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbXGIKVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbXGIKVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXGIKU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:20:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:36230 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXGIKU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:20:57 -0400
Message-ID: <46920C0F.8000506@qumranet.com>
Date: Mon, 09 Jul 2007 13:21:03 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <1183971001.4254.3.camel@sli10-conroe.sh.intel.com> <469203E9.7000109@qumranet.com>
In-Reply-To: <469203E9.7000109@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Shaohua Li wrote:
>> On Sun, 2007-07-08 at 20:58 +0800, Avi Kivity wrote:
>>  
>>> The only fly in the ointment is that it crashes quite soon.  Haven't
>>> figured
>>> out why yet, but comments on the general direction would be welcome.
>>>     
>> Attached patch seems help in my test. prepare_task_switch is called with
>> irq disabled.
>>
>>
>>   
>
> Thanks!!  Will integrate that.
>


I've committed and pushed this into a new 'sched' branch on kvm.git.  
I'll continually rebase this against 'master'.


-- 
error compiling committee.c: too many arguments to function

