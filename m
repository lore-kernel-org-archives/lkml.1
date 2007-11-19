Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbXKSSvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbXKSSvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXKSSv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:51:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44815 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbXKSSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:51:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] task_pid_nr_ns() breaks proc_pid_readdir()
References: <20071117181549.GA1415@tv-sign.ru>
	<m1bq9swqyu.fsf@ebiederm.dsl.xmission.com>
	<20071118142047.GA360@tv-sign.ru>
	<m1tzniumoo.fsf@ebiederm.dsl.xmission.com>
	<20071119182937.GA89@tv-sign.ru>
Date: Mon, 19 Nov 2007 11:50:15 -0700
In-Reply-To: <20071119182937.GA89@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 19 Nov 2007 21:29:37 +0300")
Message-ID: <m1pry6ul20.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 11/19, Eric W. Biederman wrote:
>>
>> I think we can solve the immediate issues cleanly
>> without it, and we are pretty much in bug fixing territory now.
>
> Yes sure. Besides, the "patch" I showed for illustration is not complete,
> and it is not easy to solve the problems with exec().
>
> Could you re-send your patch with changelog to Andrew? I agree, it is better
> to pass a pointer than to add the horrible hack to proc_pid_readdir().

Definitely. I'm just testing now to make certain my code actually works.
I have respun my patch to return a structure as I figured out how to
do that cleanly.

Eric
