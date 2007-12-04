Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbXLDMxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbXLDMxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXLDMxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:53:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51610 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXLDMxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:53:01 -0500
Date: Tue, 4 Dec 2007 13:52:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Liam Howlett <howlett@gmail.com>
Cc: linux-kernel@vger.kernel.org, willy@linux.intel.com,
       akpm@linux-foundation.org, mingo@redhat.com
Subject: Re: [Patch 0/2] Kernel: mutex_lock_killable
Message-ID: <20071204125239.GB31590@elte.hu>
References: <68d904ba0711280552i4ee6637j47c7ee2f72a77661@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d904ba0711280552i4ee6637j47c7ee2f72a77661@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Liam Howlett <howlett@gmail.com> wrote:

> Hello,
> 
> This series of patches add the ability to make mutex locks killable 
> instead of uninterruptable.
> 
> This patch set builds on willys 5 patches for TASK_KILLABLE that are 
> currently in mm (see http://lkml.org/lkml/2007/10/18/423 for more 
> details).  I have used 2.6.24-rc3 with the addition of willys patches.
> 
> The first patch adds the mutex_lock_killable to the kernel/mutex.c and 
> kernel/mutex.h.
> 
> The second patch is a use of the mutex_lock_killable to fs/readdir.c 
> to use the new mutex_lock_killable.  This was enough for a small test 
> application to be killable once the ethernet was pulled on an nfs 
> mount (please note that this does not allow a normal ls to be killed 
> yet).

nice patches!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
