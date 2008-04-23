Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYDWVPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYDWVPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYDWVPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:15:09 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:35885 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYDWVPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:15:06 -0400
Message-ID: <480FA729.3000406@seznam.cz>
Date: Wed, 23 Apr 2008 23:16:25 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [RFC] Introduce __ARCH_WANT_SYS_SYSFS
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804221515.28075.arnd@arndb.de>
In-Reply-To: <200804221515.28075.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd and others,

I would like to fix syscalls in Microblaze repo. Can you give me a hint how to
do it?

I look at Blackfin arch and I compared files with microblaze. There are some
differences but not so much.
Can you tell me how to test it which syscall is necessary for platform.
I have never found any documentation about.

In my syscall_table.S (on some arch in entry.S) is one big jump table with
reference to syscalls. In unistd.h is definition.

Is there any convention which syscalls are use for all archs and which are
architecture specific?

Thanks for info,
Michal Simek

>> This patch introduces a __ARCH_WANT_SYS_SYSFS #define for
>> architectures that support the sysfs(2) system call. At the moment
>> that's everybody but blackfin, but future architectures may want to
>> save the (admittedly small) code size that it adds to the kernel as
>> well.
> 
> Yes, good thing to have. Since we'll be getting a new architecture
> (microblaze) soon, I think we should extend this mechanism (even though
> it's ugly) to all syscalls that we don't want to have in new architectures
> and make sure that microblaze doesn't have to set any of them.
> 
> 	Arnd <><
> 
