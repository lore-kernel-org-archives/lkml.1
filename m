Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbYEFPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbYEFPVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbYEFPVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:21:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbYEFPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:21:07 -0400
Message-ID: <4820767D.8040202@zytor.com>
Date: Tue, 06 May 2008 08:17:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mikael Pettersson <mikpe@it.uu.se>, tglx@linutronix.de, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 lies about PAT not being available
References: <18464.5177.649312.999486@harpo.it.uu.se> <20080506114839.GD32591@elte.hu>
In-Reply-To: <20080506114839.GD32591@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I know about Intel's PAT erratum (only 4 PAT entries work) and 
>> understand that the kernel might not want to use a half-broken PAT 
>> implementation, but the statement above is blatantly false: the kernel 
>> IS built with PAT support and the CPU DOES have (half-broken) PAT HW 
>> support as /proc/cpuinfo from earlier kernels confirms.
> 
> well the code is just being overly conservative, and the message is 
> right: the kernel does not support PAT on that hw. Yet.
> 
> Please send us a patch and test whether it's working on your box? That's 
> how the PAT code evolved: it initially was only enabled on a very small 
> subset of CPUs. We can enable it on more CPUs if people test it.
> 
> To be conservative, please make the code emit a printk that this is PAT 
> on not fully-working hw platform (only 4 PAT entries work). If there 
> _is_ some erratum on that CPU affecting PAT reliability down the line, 
> we at least want to have some clue in the syslog.
> 

For what it's worth, we only use four PAT entries, so it doesn't matter 
that only four work.

	-hpa

