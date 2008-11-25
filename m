Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYKYP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYKYP0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYKYPZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:25:58 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:42480 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYKYPZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:25:57 -0500
Message-ID: <492C1904.9020309@oracle.com>
Date: Tue, 25 Nov 2008 07:25:56 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       suparna@in.ibm.com, linux-aio@kvack.org, Jeff Moyer <jmoyer@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kvm aio wishlist
References: <492B0CDD.7080000@redhat.com> <492B2348.9090008@oracle.com> <492B2976.3010209@redhat.com> <492B3912.3030707@oracle.com> <492BC5CB.6000609@redhat.com> <20081125101923.GA28123@in.ibm.com> <492BD807.4000002@redhat.com> <20081125145949.GD14147@elte.hu> <20081125151058.GX26308@kernel.dk>
In-Reply-To: <20081125151058.GX26308@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Still unsure why that stuff never got anywhere.

Changing the tid of submitting tasks makes it unsuitable for sys_io_*()
or posix aio users as it stands.  Maybe we could swap tids on the
switch, but we'd probably then have to audit the life time of tid ->
task_struct users in the kernel.

And there's still the question of what ptrace is supposed to do.

- z
