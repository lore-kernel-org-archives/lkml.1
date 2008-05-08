Return-Path: <linux-kernel-owner+w=401wt.eu-S1764410AbYEHRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764410AbYEHRBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763600AbYEHRA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:00:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763237AbYEHRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:00:56 -0400
Message-ID: <48232DCF.2070907@zytor.com>
Date: Thu, 08 May 2008 09:43:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl>	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	<20080507124650.GD29935@cs181133002.pp.htv.fi>	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>	<48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com>	<48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com>	<alpine.LFD.1.10.0805071707150.3024@woody.linux-foundation.org>	<482249E4.2040102@zytor.com> <87d4nxayr4.fsf@basil.nowhere.org>
In-Reply-To: <87d4nxayr4.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>> Well, there *is* support for that - all the raw information is there
>> in /dev/cpu/*/cpuid.  There are other reasons why /proc/cpuinfo is the
>> wrong interface to try to get the "real" CPUID information - we only
>> report CPU features that the kernel knows about; bits we don't, if we
>> can decode them at all, we just don't show.
> 
> They are reported as numbers (assuming they are in the existing leaves)

No, they're not.

	-hpa
