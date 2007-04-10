Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXDJAgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXDJAgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965996AbXDJAgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:36:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58958 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXDJAgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:36:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
References: <20070409020600.6338BD82F4@pipsqueak.sf.frob.com>
	<m11wit34fo.fsf@ebiederm.dsl.xmission.com>
	<20070409173053.GD22997@lnx-holt.americas.sgi.com>
Date: Mon, 09 Apr 2007 18:35:39 -0600
In-Reply-To: <20070409173053.GD22997@lnx-holt.americas.sgi.com> (Robin Holt's
	message of "Mon, 9 Apr 2007 12:30:53 -0500")
Message-ID: <m1r6qtyskk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> OK.  I just got the OK from management.  The system we were booting was
> for research only.  We had NR_CPUS=num_online_cpus()=4096 which were
> non-hyperthreaded.  With no attached I/O and the tweak I originally
> posted plus one change Jack has already gotten accepted, the machine
> booted in approx 12 minutes.

How much of that time was between the time the kernel was loaded
and before user space was started?

Twelve minutes sounds like a long time for a boot, if you aren't fsck'ing
filesystems.

Eric
