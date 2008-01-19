Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYASTlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYASTlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYASTla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:41:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbYASTl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:41:28 -0500
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: =?us-ascii?Q?=3D=3FISO-8859-1=3FQ=3FT=3DF6r=3DF6k=5FEdwin=3F=3D?= 
	<edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] LatencyTop: make reason (blk_execute_rq+0x7a/0xd) known
References: <47922B2A.7070709@gmail.com> <479241B0.8010500@linux.intel.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sat, 19 Jan 2008 14:40:11 -0500
In-Reply-To: <479241B0.8010500@linux.intel.com> (Arjan van de Ven's message of "Sat, 19 Jan 2008 10:30:08 -0800")
Message-ID: <y0mir1py57o.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:

> Török Edwin wrote:
>> [...]
>> P.S.: LatencyTop could have a feature to ask for more details on unknown
>> latency reasons, and it would generate a systemtap script itself, that
>> would show the backtraces to help figure out whats going on.
>
> I've considered having an option inside the code itself that would print a
> backtrace for, say, an unknown latency larger than 100msec
> but the code got ugly (the accounting gets done in the scheduler path,
> where you can't printk). [...]

Systemtap does not use printk, and can generate decent backtraces from
the kernel (and into userspace before too long).  (FWIW, it seems to
be only a small stretch to implement tools like *top via systemtap
rather than custom-written kernel code.)

- FChE
