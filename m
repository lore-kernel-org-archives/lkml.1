Return-Path: <linux-kernel-owner+w=401wt.eu-S1946211AbXBII1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946211AbXBII1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946212AbXBII1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:27:45 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40467 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946211AbXBII1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:27:44 -0500
Date: Fri, 9 Feb 2007 09:26:11 +0100
From: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
To: "Bharata B Rao" <bharata.rao@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-ID: <20070209092611.72c221d3@frecb000686.frec.bull.fr>
In-Reply-To: <344eb09a0702082132w100e3b27saea61ee30a28b50a@mail.gmail.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<344eb09a0702082132w100e3b27saea61ee30a28b50a@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 09/02/2007 09:28:52,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 09/02/2007 09:28:52,
	Serialize complete at 09/02/2007 09:28:52
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 11:02:28 +0530 "Bharata B Rao" <bharata.rao@gmail.com> wrote:

> Andrew,
> 
> On 2/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
> > fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
> > fsaio-rename-__lock_page-to-lock_page_blocking.patch
> > fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
> > fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
> > fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
> > fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
> > fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
> > fsaio-enable-asynchronous-wait-page-and-lock-page.patch
> > fsaio-filesystem-aio-read.patch
> > fsaio-aio-o_sync-filesystem-write.patch
> >
> >  Will wait to see what happens with febrils.
> >
> > aio-is-unlikely.patch
> >
> >  Will merge.
> >
> > rework-compat_sys_io_submit.patch
> > fix-aioh-includes.patch
> > fix-access_ok-checks.patch
> > make-good_sigevent-non-static.patch
> > make-good_sigevent-non-static-fix.patch
> > make-__sigqueue_free-and.patch
> > aio-completion-signal-notification.patch
> > aio-completion-signal-notification-fix.patch
> > aio-completion-signal-notification-fixes-and-cleanups.patch
> > aio-completion-signal-notification-small-cleanup.patch
> > add-listio-syscall-support.patch
> >
> >  I guess these are dependent upon fsaio.
> 
> No. AIO completion signal notification patches and listio patch work
> independently of fsaio patches. Just that for buffered AIO case, the
> fsaio patches will make the behaviour truly asynchronous.
> 
> Regards,
> Bharata.

  I concur.

  Thanks,

  Sébastien.

