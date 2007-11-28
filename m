Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbXK1CLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbXK1CLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759811AbXK1CLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:11:16 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46935 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765AbXK1CLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:11:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org,
       jack@suse.cz, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: /proc dcache deadlock in do_exit
References: <20071127132022.GW6840@v2.random>
	<20071127143852.601509ac.akpm@linux-foundation.org>
Date: Tue, 27 Nov 2007 19:09:58 -0700
In-Reply-To: <20071127143852.601509ac.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 27 Nov 2007 14:38:52 -0800")
Message-ID: <m1ejebglxl.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Andrew Morton <akpm@linux-foundation.org> writes:

> I don't see why the schedule() will not return?  Because the task has
> PF_EXITING set?  Doesn't TASK_DEAD do that?

This appears to be a work around for an old bug only present in sles9.

It looks like it has been safe to schedule in release task for years
in mainline, and that is simply much more robust.

Eric
