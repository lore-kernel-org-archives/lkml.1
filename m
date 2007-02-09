Return-Path: <linux-kernel-owner+w=401wt.eu-S1946236AbXBIJGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946236AbXBIJGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946237AbXBIJGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:06:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946236AbXBIJGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:06:08 -0500
Date: Fri, 9 Feb 2007 01:05:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= <sebastien.dugue@bull.net>
Cc: "Bharata B Rao" <bharata.rao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070209010557.6506d39a.akpm@linux-foundation.org>
In-Reply-To: <20070209092611.72c221d3@frecb000686.frec.bull.fr>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<344eb09a0702082132w100e3b27saea61ee30a28b50a@mail.gmail.com>
	<20070209092611.72c221d3@frecb000686.frec.bull.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 09:26:11 +0100 Sébastien Dugué <sebastien.dugue@bull.net> wrote:

> On Fri, 9 Feb 2007 11:02:28 +0530 "Bharata B Rao" <bharata.rao@gmail.com> wrote:
> 
> > Andrew,
> > 
> > On 2/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
> > > fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
> > > fsaio-rename-__lock_page-to-lock_page_blocking.patch
> > > fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
> > > fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
> > > fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
> > > fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
> > > fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
> > > fsaio-enable-asynchronous-wait-page-and-lock-page.patch
> > > fsaio-filesystem-aio-read.patch
> > > fsaio-aio-o_sync-filesystem-write.patch
> > >
> > >  Will wait to see what happens with febrils.
> > >
> > > aio-is-unlikely.patch
> > >
> > >  Will merge.
> > >
> > > rework-compat_sys_io_submit.patch
> > > fix-aioh-includes.patch
> > > fix-access_ok-checks.patch
> > > make-good_sigevent-non-static.patch
> > > make-good_sigevent-non-static-fix.patch
> > > make-__sigqueue_free-and.patch
> > > aio-completion-signal-notification.patch
> > > aio-completion-signal-notification-fix.patch
> > > aio-completion-signal-notification-fixes-and-cleanups.patch
> > > aio-completion-signal-notification-small-cleanup.patch
> > > add-listio-syscall-support.patch
> > >
> > >  I guess these are dependent upon fsaio.
> > 
> > No. AIO completion signal notification patches and listio patch work
> > independently of fsaio patches. Just that for buffered AIO case, the
> > fsaio patches will make the behaviour truly asynchronous.
> > 
> > Regards,
> > Bharata.
> 
>   I concur.
> 

But is the proposed listio implementation still relevant if we go and add
the async syscalls? 
