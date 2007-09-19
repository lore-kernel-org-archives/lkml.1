Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbXISIyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbXISIyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbXISIyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:54:44 -0400
Received: from il.qumranet.com ([82.166.9.18]:47714 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbXISIym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:54:42 -0400
Message-ID: <46F0E3C1.7080103@qumranet.com>
Date: Wed, 19 Sep 2007 10:54:25 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: =?windows-1252?Q?Re=3A_2=2E6=2E23-rc6-mm1_--_drivers/kvm/i?=
 =?windows-1252?Q?oapic=2Ec=3A_In_function_=91ioapic=5Fdeliver=92=3A?=
 =?windows-1252?Q?_error=3A_=91dest=5FLowestPrio=92_undeclared_=28?=
 =?windows-1252?Q?first_use_in_this_function=29?=
References: <a44ae5cd0709180936o73fcc276kbedce6051d387744@mail.gmail.com>
In-Reply-To: <a44ae5cd0709180936o73fcc276kbedce6051d387744@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
>   CC [M]  drivers/kvm/ioapic.o
> drivers/kvm/ioapic.c: In function 'ioapic_deliver':
> drivers/kvm/ioapic.c:204: error: 'dest_LowestPrio' undeclared (first
> use in this function)
> drivers/kvm/ioapic.c:204: error: (Each undeclared identifier is
> reported only once
> drivers/kvm/ioapic.c:204: error: for each function it appears in.)
> drivers/kvm/ioapic.c:215: error: 'dest_Fixed' undeclared (first use in
> this function)
>
>   

Fixed & pushed to kvm.git.  Thanks for the report.

-- 
error compiling committee.c: too many arguments to function

