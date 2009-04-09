Return-Path: <linux-kernel-owner+w=401wt.eu-S936665AbZDIU3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936665AbZDIU3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762252AbZDIU33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:29:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:48202 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761949AbZDIU33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:29:29 -0400
Cc: oleg@redhat.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
In-Reply-To: <20090409194912.GA30645@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible ptrace issue?)
Date: Thu, 9 Apr 2009 15:28:31 -0500
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org> <20090409194912.GA30645@us.ibm.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 2:49 PM, Sukadev Bhattiprolu wrote:

> Kumar Gala [galak@kernel.crashing.org] wrote:
>>
>> On Apr 9, 2009, at 10:43 AM, Kumar Gala wrote:
>>
>>> I'm seeing some weird behavior in 2.6.30-rc1 that didn't exist in  
>>> 2.6.29.
>>> We have a slightly older LTP version (20080131) that we run on some
>>> embedded PPC boards.  If I run the syscall tests on 2.6.29 things  
>>> pass as
>
> Will try to repro on a normal machine, but can you attach the /proc/ 
> pid/status
> (and possibly the stack) of the parent of the 'recv01' ?

Name:   recv01
State:  Z (zombie)
Tgid:   2449
Pid:    2449
PPid:   1
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 0
Groups: 0 1 2 3 4 6 10
Threads:        1
SigQ:   8/16384
SigPnd: 0000000000000000
ShdPnd: 0000000000004100
SigBlk: 0000000000000000
SigIgn: 0000000000000000
SigCgt: 0000000000000000
CapInh: 0000000000000000
CapPrm: fffffffffffffeff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        6
nonvoluntary_ctxt_switches:     0

If you have suggestion on how to dump the stack I can provide that as  
well.

> If the parent is 'init', is there anything special about the init on  
> your board
> or on the simulator - like are you running the tests in a container ?

Its an old init from fedora 3 or something like that.  Its not running  
in any special way (not container, no hypervisor, etc.)

- k
