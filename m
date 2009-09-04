Return-Path: <linux-kernel-owner+w=401wt.eu-S933322AbZIDJZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbZIDJZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbZIDJZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:25:43 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:41201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933280AbZIDJZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:25:42 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 0/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
In-Reply-To: David Howells's message of  Friday, 4 September 2009 09:47:31 +0100 <30057.1252054051@redhat.com>
References: <20090903160510.GA23638@redhat.com>
	<30057.1252054051@redhat.com>
X-Windows: a terminal disease.
Message-Id: <20090904092211.C57138B12A@magilla.sf.frob.com>
Date: Fri,  4 Sep 2009 02:22:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > [PATCH 0/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
> 
> I don't see where it is sleeping in TASK_TRACED with cred_guard_mutex held.

search_binary_handler calls tracehook_report_exec, which calls
ptrace_notify when PTRACE_O_TRACEEXEC is enabled.


Thanks,
Roland


