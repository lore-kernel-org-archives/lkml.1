Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZA0Vzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZA0Vzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZA0Vzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:55:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:35729 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZA0Vzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:55:31 -0500
To: Dave Anderson <anderson@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com, Mike Snitzer <snitzer@gmail.com>
Subject: Re: BISECTED: Re: source line numbers with x86_64 modules?
References: <1457226967.823651233090019084.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jan 2009 13:55:34 -0800
In-Reply-To: <1457226967.823651233090019084.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com> (Dave Anderson's message of "Tue\, 27 Jan 2009 16\:00\:19 -0500 \(EST\)")
Message-ID: <m1eiyobei1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Anderson <anderson@redhat.com> writes:

> Actually it's not a problem with the vmlinux file, but rather with kernel
> module object files.  The crash utility has an embedded gdb module which
> is invoked as "gdb vmlinux", and to get line numbers, the crash utility
> simply uses the relevant built-in gdb function to get them.  And line
> numbers work fine with the base kernel code from the vmlinux file.
>
> The debuginfo data of kernel modules can be subsequently added to the
> crash session by doing a gdb "add-symbol-file" command for any or all
> kernel modules.  But getting correct line number information for kernel
> modules has been a crap-shoot in the past, depending upon architecture
> and/or kernel version.  For example, they don't work with 2.6.9-based
> RHEL4 x86_64 kernel modules, but work fine with 2.6.18-based RHEL5 x86_64
> kernels.
>
> Looking at Mike's suspect kernel patch list, I don't see anything that
> would have any relationship to the issue.  Perhaps there was a build tool
> change during the same timeframe? 

It look like Mike just built a series of kernels and had a problem,
which should preclude a tool change.

That said.  Does this feature of crash work in 2.6.29?  If not is
there enough interest to track this down, and fix it if it is a kernel
bug?

If we are going to be using these tools we need them working on the
latest and greatest kernels, not some weird enterprise branch, for
fuddy duddies.

Eric
