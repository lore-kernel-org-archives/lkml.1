Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbZJNCc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbZJNCc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZJNCcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:32:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZJNCcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:32:24 -0400
Message-ID: <4AD5365E.5090709@zytor.com>
Date: Tue, 13 Oct 2009 19:24:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com,
       arnd@arndb.de, Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com> <4AD511F1.7010207@zytor.com> <20091014013936.GC27627@count0.beaverton.ibm.com>
In-Reply-To: <20091014013936.GC27627@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 06:39 PM, Matt Helsley wrote:
> On Tue, Oct 13, 2009 at 04:49:05PM -0700, H. Peter Anvin wrote:
>> On 10/12/2009 09:49 PM, Sukadev Bhattiprolu wrote:
>>>
>>> This patchset implements a new system call, clone3() that lets a process
>>> specify the pids of the child process.
>>>
>>
>> A system call named clone3() taking two parameters is just too weird to
>> live.  No, please.
> 
> Except we can't use clone2() because it conflicts on ia64.  Care to propose
> a name you would prefer?
> 
> Also I was a bit suprised to discover there are plenty of examples where this
> convention has not been followed: vm86, lseek64, and mmap2 to name a few. In
> fact, of the 46 __NR_foo[[:digit:]]+, 36 break this convention on x86-32.
> 

The -86, -64 and so on are visually obviously not a parameter count.
sys_mmap2 is not user visible, and so doesn't really matter.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

