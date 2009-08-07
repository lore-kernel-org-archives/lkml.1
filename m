Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZHGV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZHGV0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZHGV03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:26:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:46769 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753699AbZHGV03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:26:29 -0400
X-Authenticated: #2360897
X-Provags-ID: V01U2FsdGVkX1+lafVas2alARIaQnJIiD7wLWjBxpwXCOwZNmbKGW
	MNPcfw5x8T/F9A
Message-ID: <4A7C9BF1.8070700@gmx.de>
Date: Fri, 07 Aug 2009 23:26:09 +0200
From: Bernhard Walle <bernhard.walle@gmx.de>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Amerigo Wang <amwang@redhat.com>, Neil Horman <nhorman@redhat.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <4A7A3A78.7080200@redhat.com> <m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com> <m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com> <m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com> <m1iqh1nxv3.fsf@fess.ebiederm.org> <4A7A9E54.60705@redhat.com> <m1iqgze740.fsf@fess.ebiederm.org> <20090807210306.GA25609@basil.fritz.box>
In-Reply-To: <20090807210306.GA25609@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen schrieb:
>> As an initial approximation I would use a 32nd of low memory.
> 
> That means a 1TB machine will have a 32GB crash kernel.
> 
> Surely that's excessive?!?
> 
> It would be repeating all the same mistakes people made with hash tables
> several years ago.

The idea of Eric was to shrink the reserved memory in an init script. I
doubt that the 1 TB machine will have any problems or performance issue
when booting with (1 TB - 32 GB) memory.

> It doesn't sound reasonable to Andi.
> 
> Why do you even want to grow the crash kernel that much? Is there
> any real problem with a 64-128MB crash kernel?

Try it out. No chance for 64-128MB crashkernel on "medium" IA64 machines.


Regards,
Bernhard
