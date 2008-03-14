Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYCNXkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYCNXkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYCNXjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:39:52 -0400
Received: from saeurebad.de ([85.214.36.134]:38922 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYCNXjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:39:52 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, lenb@kernel.org, dhowells@redhat.com,
       peterz@infradead.org, mingo@elte.hu
Subject: Re: Updated generic semaphore patch set
References: <20080314204248.GV613@parisc-linux.org>
	<1205529813.27712.15.camel@brick>
Date: Sat, 15 Mar 2008 00:37:22 +0100
In-Reply-To: <1205529813.27712.15.camel@brick> (Harvey Harrison's message of
	"Fri, 14 Mar 2008 14:23:33 -0700")
Message-ID: <87zlt027yl.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison <harvey.harrison@gmail.com> writes:

> +/**
> + * down_killable - try to acquire the semaphore
> + * @sem: the semaphore to be acquired
> + *
> + * This can be called from interrupt context, unlike mutexes.
> + */
>  int down_interruptible(struct semaphore *sem)

Mismatching function names.

	Hannes
