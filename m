Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbZANVws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbZANVws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZANVwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:52:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:33878 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZANVwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <20090114214158.GA9992@elte.hu>
References: <1231952436.14825.28.camel@laptop>
	 <20090114105300.66bd014d.akpm@linux-foundation.org>
	 <20090114190008.GA13203@elte.hu>
	 <20090114113638.c818fcf8.akpm@linux-foundation.org>
	 <20090114201435.GA6519@elte.hu>
	 <20090114123017.9acf42d7.akpm@linux-foundation.org>
	 <20090114205122.GC6519@elte.hu>
	 <20090114130642.cf2b18b2.akpm@linux-foundation.org>
	 <20090114211458.GD6519@elte.hu> <20090114214158.GA9992@elte.hu>
Date: Wed, 14 Jan 2009 22:50:59 +0100
Message-ID: <ac3eb2510901141350x16c0f67cp46376e57062eaef9@mail.gmail.com>
Subject: Re: [GIT PULL] adaptive spinning mutexes
From: Kay Sievers <kay.sievers@vrfy.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com, ghaskins@novell.com,
       matthew@wil.cx, andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 22:41, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > You just disproved your own case :(
>>
>> how so? 80% is not enough? I also checked Fedora and it has
>> SCHED_DEBUG=y in its kernel rpms.
>
> Ubuntu has CONFIG_SCHED_DEBUG=y as well in their kernels.

$ cat /etc/SuSE-release
openSUSE 11.1 (x86_64)
VERSION = 11.1

$ uname -a
Linux nga 2.6.27.7-9-default #1 SMP 2008-12-04 18:10:04 +0100 x86_64
x86_64 x86_64 GNU/Linux

$ zgrep SCHED_DEBUG /proc/config.gz
CONFIG_SCHED_DEBUG=y

$ zgrep DEBUG_MUTEX /proc/config.gz
# CONFIG_DEBUG_MUTEXES is not set

Kay
