Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbYEAX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbYEAX5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYEAX5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:57:38 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:30829 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751006AbYEAX5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:57:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MQfAFbbhB/NKjZ2Q87BL2hWrfeSh8+CEQLGeFoIXvMxJG1G3r91nhDfKO8lYtC5Df47r0x9Pp+FfpM4jm+cW16T7v3QiJiuWCAfYX3GtOhTrZygHwLJplwJHqs7ltWsaQwap48Pbh2v0msvUeO/FBdkLjjGQvRSgFTLzJdGofdM=  ;
X-YMail-OSG: 1gtrPHIVM1nk0Ogi3TBWhmUlVNp0livhfIYHgKalAOu4nDOjNprkA0qBDcSoyCcvmoLtaEUlhLrdAtA9vQ4PLVQPGPQKXGQbi.uHnfb1FVtBvpJZ6iy4d3A6wVuz5zdtKIi8f826bOs_rYfkbxfB8g2f
X-Yahoo-Newman-Property: ymail-3
Message-ID: <481A58A2.7070807@sbcglobal.net>
Date: Thu, 01 May 2008 16:56:18 -0700
From: Ryan Roth <ryanroth@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Ryan.Roth@CH2M.com, akpm@linux-foundation.org,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting
 With 2.6.24.5 Kernel
References: <bug-10586-10286@http.bugzilla.kernel.org/>	<20080501130444.cc5c63e8.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>	<20080501133003.be723364.akpm@linux-foundation.org>	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>	<481A5276.4040607@sbcglobal.net> <20080501164856.f93ff909.randy.dunlap@oracle.com>
In-Reply-To: <20080501164856.f93ff909.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 01 May 2008 16:29:58 -0700 Ryan Roth wrote:
>
>   
>>> -----Original Message-----
>>> From: Andrew Morton [mailto:akpm@linux-foundation.org]
>>> Sent: Thu 5/1/2008 1:30 PM
>>> To: Roth, Ryan/RDD
>>> Cc: bugme-daemon@bugzilla.kernel.org; linux-kernel@vger.kernel.org
>>> Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults 
>>> onMacBookStarting With 2.6.24.5 Kernel
>>>
>>> On Thu, 1 May 2008 14:09:00 -0600
>>> <Ryan.Roth@CH2M.com> wrote:
>>>       
>>>> -----Original Message-----
>>>>         
>>>>> From: Andrew Morton [mailto:akpm@linux-foundation.org]
>>>>> Sent: Thursday, May 01, 2008 1:05 PM
>>>>> To: Roth, Ryan/RDD
>>>>> Cc: bugme-daemon@bugzilla.kernel.org; linux-kernel@vger.kernel.org
>>>>> Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
>>>>> onMacBook Starting With 2.6.24.5 Kernel
>>>>>
>>>>> (switched to email.  Please respond via emailed reply-to-all, not via
>>>>> the bugzilla web interface).
>>>>>
>>>>> On Thu,  1 May 2008 12:30:18 -0700 (PDT)
>>>>> bugme-daemon@bugzilla.kernel.org wrote:
>>>>>
>>>>>           
>>>>>> http://bugzilla.kernel.org/show_bug.cgi?id=10586
>>>>>>
>>>>>>            Summary: High Number of Segfaults on MacBook Starting 
>>>>>>             
>>> With
>>>       
>>>>>>                     2.6.24.5 Kernel
>>>>>>            Product: Memory Management
>>>>>>            Version: 2.5
>>>>>>      KernelVersion: 2.6.24.5
>>>>>>           Platform: All
>>>>>>         OS/Version: Linux
>>>>>>               Tree: Mainline
>>>>>>             Status: NEW
>>>>>>           Severity: normal
>>>>>>           Priority: P1
>>>>>>          Component: Other
>>>>>>         AssignedTo: akpm@osdl.org
>>>>>>         ReportedBy: ryan.roth@ch2m.com
>>>>>>
>>>>>>
>>>>>> Latest working kernel version:  2.6.23?
>>>>>> Earliest failing kernel version:  2.6.24.5
>>>>>> Distribution: Fedora 8 x86_64
>>>>>> Hardware Environment:  MacBook
>>>>>> Problem Description:  Extremely high number of segfaults.  Suspect
>>>>>> that this may have to do with some sort of change in memory 
>>>>>>             
>>> remapping
>>>       
>>>>>> changes in the kernel.
>>>>>>             
>>>>> This report is a bit mysterious.  I assume you're referring to x86's
>>>>>
>>>>>     "%s%s[%d]: segfault at %lx ip %08lx sp %08lx error %lx"
>>>>>
>>>>> printk in the kernel logs?
>>>>>
>>>>> Can you please send some examples of the log output?
>>>>>
>>>>> Is there actually any observeable problem apart from the logs?  Are
>>>>> applications dying where they previously did not?
>>>>>
>>>>>           
>>>> Yes there is a issue with a lot of apps dying, especially the
>>>> gnome-power-* apps which means my power management fails to work
>>>> frequently.  I'm on Git-10 currently and I'm going to patch it up to
>>>> date right now because it looks like there have been some memory remap
>>>> patches lately.  I will update the list after I do so.
>>>>
>>>>         
>>> OK, worried.  This is a huge bug.  But afaik you're the only person 
>>> who has
>>> hit it, so there must be something special in your setup which is
>>> triggering it.  This could be hard.
>>>
>>>       
>> OK here is what I get with the git16 kernel.  On boot I get this error:
>>
>> PCI: Not using MMCONFIG
>> PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard 
>> resources
>> PCI: Not using MMCONFIG
>>
>> Attached is a complete log after this boot
>>     
>
> Where are the segfaults?
>
> Do you mean these reports?  If so, then this is something
> other than segfaults.  And not quite as critical.
> Or are things not working for you with this kernel?
>
>
> May  1 16:15:01 kernel: proc_dir_entry 'info' already registered
> May  1 16:15:01 kernel: Pid: 1099, comm: modprobe Not tainted 2.6.25-git16 #3
> May  1 16:15:01 kernel: 
> May  1 16:15:01 kernel: Call Trace:
> May  1 16:15:01 kernel:  [<ffffffff81118269>] idr_get_new+0xb/0x28
> May  1 16:15:01 kernel:  [<ffffffff810d5e92>] proc_register+0xcb/0x14b
> May  1 16:15:01 kernel:  [<ffffffff810d5ec5>] proc_register+0xfe/0x14b
> May  1 16:15:01 kernel:  [<ffffffff810d5f96>] proc_create_data+0x84/0x9e
> May  1 16:15:01 kernel:  [<ffffffffa013dd37>]
> :video:acpi_video_bus_add+0x98f/0xc6d
> May  1 16:15:01 kernel:  [<ffffffff8115d4d9>] acpi_device_probe+0x43/0x91
> May  1 16:15:01 kernel:  [<ffffffff81192564>] driver_probe_device+0xd0/0x14d
> May  1 16:15:01 kernel:  [<ffffffff81192627>] __driver_attach+0x46/0x6d
> May  1 16:15:01 kernel:  [<ffffffff811925e1>] __driver_attach+0x0/0x6d
> May  1 16:15:01 kernel:  [<ffffffff81191f09>] bus_for_each_dev+0x44/0x6f
> May  1 16:15:01 kernel:  [<ffffffff8119186e>] bus_add_driver+0xb2/0x1ff
> May  1 16:15:01 kernel:  [<ffffffff81192846>] driver_register+0x59/0xcd
> May  1 16:15:01 kernel:  [<ffffffffa00d803c>] :video:acpi_video_init+0x3c/0x5e
> May  1 16:15:01 kernel:  [<ffffffff81052db2>] sys_init_module+0x171a/0x1896
> May  1 16:15:01 kernel:  [<ffffffff8115d812>] acpi_bus_register_driver+0x0/0x3e
> May  1 16:15:01 kernel:  [<ffffffff81098831>] vfs_read+0xa6/0xfe
> May  1 16:15:01 kernel:  [<ffffffff8100bf3b>]
> system_call_after_swapgs+0x7b/0x80
> ---
> ~Randy
>
>   
The segfaults are still present causing apps to not work.  I attached a 
boot log in case it was needed for more details.  Should I not worry 
about the following message?

May  1 16:15:01 kernel: PCI: MCFG configuration 0: base f0000000 segment 
0 buses 0 - 255
May  1 16:15:01 kernel: PCI: BIOS Bug: MCFG area at f0000000 is not 
reserved in ACPI motherboard resources
May  1 16:15:01 kernel: PCI: Not using MMCONFIG.
