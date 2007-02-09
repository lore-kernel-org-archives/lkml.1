Return-Path: <linux-kernel-owner+w=401wt.eu-S1946115AbXBIFca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946115AbXBIFca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 00:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946121AbXBIFca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 00:32:30 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:20754 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946115AbXBIFc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 00:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hGTRRI4xTqCPYLP82+wdk9v4pRQb9ZqpABBOUglA2+5oVgvkv6zV5ZNkIVaB6hb1es8XdtxygoO7gaq3gv4/5eMPvmgqxGLB/X0coFDxsssjtxELcgBFxMN/w7NUIdACZgmMx2yT7pBLK+iFpMge9/ByCCLFR6gKHwDYbES8MYE=
Message-ID: <344eb09a0702082132w100e3b27saea61ee30a28b50a@mail.gmail.com>
Date: Fri, 9 Feb 2007 11:02:28 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: -mm merge plans for 2.6.21
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On 2/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
> fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine-gfs2-fix.patch
> fsaio-rename-__lock_page-to-lock_page_blocking.patch
> fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
> fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
> fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
> fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
> fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
> fsaio-enable-asynchronous-wait-page-and-lock-page.patch
> fsaio-filesystem-aio-read.patch
> fsaio-aio-o_sync-filesystem-write.patch
>
>  Will wait to see what happens with febrils.
>
> aio-is-unlikely.patch
>
>  Will merge.
>
> rework-compat_sys_io_submit.patch
> fix-aioh-includes.patch
> fix-access_ok-checks.patch
> make-good_sigevent-non-static.patch
> make-good_sigevent-non-static-fix.patch
> make-__sigqueue_free-and.patch
> aio-completion-signal-notification.patch
> aio-completion-signal-notification-fix.patch
> aio-completion-signal-notification-fixes-and-cleanups.patch
> aio-completion-signal-notification-small-cleanup.patch
> add-listio-syscall-support.patch
>
>  I guess these are dependent upon fsaio.

No. AIO completion signal notification patches and listio patch work
independently of fsaio patches. Just that for buffered AIO case, the
fsaio patches will make the behaviour truly asynchronous.

Regards,
Bharata.
