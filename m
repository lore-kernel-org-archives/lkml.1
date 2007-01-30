Return-Path: <linux-kernel-owner+w=401wt.eu-S1752127AbXA3Q0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbXA3Q0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXA3Q0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:26:52 -0500
Received: from smtp23.orange.fr ([193.252.22.126]:57074 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbXA3Q0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:26:51 -0500
X-ME-UUID: 20070130162649322.4ECB170000B1@mwinf2324.orange.fr
Message-ID: <45BF71CA.6090200@free.fr>
Date: Tue, 30 Jan 2007 17:26:50 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.0.7) Gecko/20060405 SeaMonkey/1.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] compile and link utsname_sysctl.o
References: <20070129001207.71ea3470.akpm@osdl.org> <45BE6E4C.60207@free.fr> <m1tzy8h7mc.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzy8h7mc.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Le 30.01.2007 16:11, Eric W. Biederman a écrit :
> Laurent Riffard <laurent.riffard@free.fr> writes:
> 
>> The utsname stuff has been moved from kernel/sysctl.c to the new file
>> utsname_sysctl.c. Let's use it...
>>
>> Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
> 
> Hmm.  Maybe something got lost along the way but I have this
> line in my kernel/Makefile and in the patch I sent out.
> 
> obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
> 
> Do you not have that?

mmm...

linux-2.6-mm$ grep SYSCTL kernel/Makefile
linux-2.6-mm$ echo $?
1

linux-2.6-mm$ grep SYSCTL .config
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_SYSCTL=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_PROC_SYSCTL=y

tmp$ grep "obj-\$(CONFIG_SYSCTL)" broken-out/*
tmp$ echo $?
1
tmp$

> What problem are you seeing?

Some /proc files were lacking: 
/proc/sys/kernel/{osrelease|osrelease|version|...}.

-- 
laurent

