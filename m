Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbXDJW2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbXDJW2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030573AbXDJW2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:28:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40393 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030555AbXDJW2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:28:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] reduce reparent_to_init()
References: <20070410185027.GA101@tv-sign.ru>
Date: Tue, 10 Apr 2007 16:27:04 -0600
In-Reply-To: <20070410185027.GA101@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 10 Apr 2007 22:50:27 +0400")
Message-ID: <m11wiryifb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Move some random stuff which doesn't need tasklist_lock from reparent_to_init()
> to its caller, daemonize(). Strictly speaking, rlim is protected by task_lock()
> but we don't need it to copy init_task->rlim.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Regardless of whatever else we are doing getting junk out of a function
whose goal is to reparent a kernel thread makes sense.

Eric
