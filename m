Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZLJPJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZLJPJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZLJPJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:09:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZLJPJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:09:07 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel <utrace-devel@redhat.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
References: <1259588232.20516.307.camel@laptop>
	<20091130150314.GA10331@redhat.com> <20091130151650.GA24316@elte.hu>
	<20091130152910.GB10331@redhat.com> <20091201161132.GA24897@elte.hu>
	<20091201170002.GD10331@redhat.com> <20091201170954.GA4699@elte.hu>
	<20091201174534.GE10331@redhat.com> <20091201211518.GA32376@elte.hu>
	<20091208215829.GA19793@redhat.com> <20091210074158.GI16874@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 10 Dec 2009 10:08:57 -0500
In-Reply-To: <20091210074158.GI16874@elte.hu> (Ingo Molnar's message of "Thu, 10 Dec 2009 08:41:58 +0100")
Message-ID: <y0mhbryamt2.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo Molnar <mingo@elte.hu> writes:

> [...]  Since the speed of development in this area is truly glacial
> at the moment and the practical advantages that i can experience
> personally (directly as a Linux user and indirectly as a maintainer)
> are miniscule so far, caution is warranted IMO. [...]

If the "caution" you suggest is operationally equivalent to
discouraging even miniscule improvements, is it any wonder that
progress is glacial?

The gdbstub prototype was constructed for two reasons: to demonstrate
utrace usage now, and in the future to be incrementally useful (over
ptrace, by moving into fast kernel-space operations like
multithreading control, gdb-tracepoint support, other stuff).  #1 is
about done.  With respect to #2, we can certainly commit to ongoing
work on improvements, provided the community shows interest and
goodwill.

- FChE
