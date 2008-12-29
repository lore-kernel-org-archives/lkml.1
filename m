Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYL2LQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYL2LQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYL2LQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:16:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:40661 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYL2LQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:16:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=SqtMcdtM3dEHPGGjZLpizqCIgZx8iHsvB34xlDt4p6+VGz5jheQcRkO4mn5tGiJX7Y
         fb+gWRGP0ZOdgFUaJrqA8EuDSKX9AZUtMJ09ewJa+4heucEbsze4jmSNBKlBSwAivNMc
         k8XUElrC3/6X5Itm1SMMC7XU50+OEfoL2hCgY=
Message-ID: <43d009740812290316v7babab12t218a0e122e05f871@mail.gmail.com>
Date: Mon, 29 Dec 2008 18:16:09 +0700
From: "Igor Podlesny" <for.poige+linux@gmail.com>
Reply-To: for.poige+linux@gmail.com
To: "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: Hi! I've noticed that kernel.org advertises 2.6.28 as "The latest stable version of the Linux kernel is".
Cc: "Christoph Hellwig" <hch@infradead.org>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4958AF9E.7070005@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.AyhwSGaa29qThLZ5OhBSbACDzmI@ifi.uio.no>
	 <fa.O2INIKnSvQY5+2WFbCRxoh8xutg@ifi.uio.no>
	 <fa.fGgFQweuOQlZ5w9soKo4267nPkc@ifi.uio.no>
	 <4958AF9E.7070005@yahoo.com>
X-Google-Sender-Auth: aac6f6b60d57cfac
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/29 Sitsofe Wheeler <sitsofe@yahoo.com>:
> Igor Podlesny wrote:
>>
>>        Yeah, I'll try to get backtraces, using null-modem cable, but alas,
>> I
>
> Have you tried compiling your kernel with extended checks
> (CONFIG_DEBUG_KERNEL in the Kernel hacking menu)? There are debug poisoning
> options too. Sometimes this can flush out problems before they become
> fatal...
>
2.6.28's:

# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_FS is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set

	-- Nothing in dmesg; when it freezes or reboots, even if there're
some messages on console, they wouldn't be seen in graphics mode. As I
said, now my suspicion is netfilter's ipt_recent; I've turned it off
and now waiting. Another kernel I'm using now (2.6.24-ovz-006.5+) is
built with stack usage reporting; that's the latest stack depth
report:

[   54.312696] modprobe used greatest stack depth: 3904 bytes left

	Dunno whether it's rather low or ok.

-- 
End of message. Next message?
