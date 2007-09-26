Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbXIZUiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbXIZUiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbXIZUio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:38:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49098 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXIZUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:38:43 -0400
Date: Wed, 26 Sep 2007 22:38:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org, xemul@openvz.org, ebiederm@xmission.com,
       menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com
Subject: Re: + uninline-find_task_by_xxx-set-of-functions.patch added to
	-mm tree
Message-ID: <20070926203808.GB4241@elte.hu>
References: <200709262035.l8QKZARn002608@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709262035.l8QKZARn002608@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> ------------------------------------------------------
> Subject: Uninline find_task_by_xxx set of functions
> From: Pavel Emelyanov <xemul@openvz.org>
> 
> The find_task_by_something is a set of macros are used to find task by pid
> depending on what kind of pid is proposed - global or virtual one.  All of
> them are wrappers above the most generic one - find_task_by_pid_type_ns() -
> and just substitute some args for it.
> 
> It turned out, that dereferencing the current->nsproxy->pid_ns construction
> and pushing one more argument on the stack inline cause kernel text size to
> grow.
> 
> This patch moves all this stuff out-of-line into kernel/pid.c.  Together
> with the next patch it saves a bit less than 400 bytes from the .text
> section.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
> Cc: Oleg Nesterov <oleg@tv-sign.ru>
> Cc: Paul Menage <menage@google.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
