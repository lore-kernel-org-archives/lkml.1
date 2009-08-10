Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZHJDKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZHJDKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZHJDKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:10:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZHJDKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:10:30 -0400
Message-ID: <4A7F8FE6.9030709@redhat.com>
Date: Mon, 10 Aug 2009 11:11:34 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>,
       Bernhard Walle <bernhard.walle@gmx.de>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com>	<m1iqh1nxv3.fsf@fess.ebiederm.org> <4A7A9E54.60705@redhat.com> <m1iqgze740.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqgze740.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Let me put this concrete proposal on the table.
>
> The problem:
>
> With the current set of crashkernel= options we are asking the
> distribution installer to perform magic.  Moving as much of this logic
> into a normal init script for better maintenance is desirable.
>
> My proposal:
>
> Implement crashkernel=max which reserves as much memory as is
> reasonable for a crash kernel, without seriously affecting stability,
> performance, and reliability.
>   

This is almost exactly what I want with crashkernel=auto....
So there's no big difference, except the name.

> As an initial approximation I would use a 32nd of low memory.
>   

Hmm, I think Bernhard's proposal is fine for this case, i.e. we can 
introduce a new syntax, "crashkernel=>>X" which means we reserve 1/2^X 
of system memory.

What do you think?

> In addition implement:
>
> /sys/kernel/crash_size
>
> That can be written to (with enough privileges when no crash kernel is
> loaded) reduce the amount of memory reserved by the crash kernel.
>   

Yeah, this is nice!

Thanks.

