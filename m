Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbXKSScD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbXKSScD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:32:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbXKSSat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:30:49 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34740 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbXKSSar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:30:47 -0500
Date: Mon, 19 Nov 2007 21:29:37 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] task_pid_nr_ns() breaks proc_pid_readdir()
Message-ID: <20071119182937.GA89@tv-sign.ru>
References: <20071117181549.GA1415@tv-sign.ru> <m1bq9swqyu.fsf@ebiederm.dsl.xmission.com> <20071118142047.GA360@tv-sign.ru> <m1tzniumoo.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzniumoo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19, Eric W. Biederman wrote:
>
> I think we can solve the immediate issues cleanly
> without it, and we are pretty much in bug fixing territory now.

Yes sure. Besides, the "patch" I showed for illustration is not complete,
and it is not easy to solve the problems with exec().

Could you re-send your patch with changelog to Andrew? I agree, it is better
to pass a pointer than to add the horrible hack to proc_pid_readdir().

Oleg.

