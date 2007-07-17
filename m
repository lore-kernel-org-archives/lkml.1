Return-Path: <linux-kernel-owner+w=401wt.eu-S936714AbXGQXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936714AbXGQXCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936420AbXGQXB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:01:59 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:46745 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936327AbXGQXB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=RtBgRwjlEptmBKfDYKc65qnHsmjlVbkjDXi3isow+hSlTSIkZCGFoqUtfylI8kjBibrc0GcGsLq+WWs04UhMeM7QKvkVOeud9vhUda+u6yCYef+akPJuPpqd5+NNgkgM8GaWqVoFM2mEnO+gihZk1dy0K3eQk+u78gilUlodQDg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 01:19:34 +0200
User-Agent: KMail/1.9.6
Cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070717065940.GZ5195@kernel.dk> <200707172252.25729.bzolnier@gmail.com> <20070717143434.48836fb8.akpm@linux-foundation.org>
In-Reply-To: <20070717143434.48836fb8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707180119.34984.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007, Andrew Morton wrote:
> On Tue, 17 Jul 2007 22:52:25 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > ide-{disk,scsi,tape} don't support REQ_TYPE_BLOCK_PC requests et all
> > (so attempts to use SG_IO, CDROM_SEND_PACKET and SCSI_IOCTL_SEND_COMMAND
> > will result in requests being failed and error messages in the kernel logs).
> 
> In my case it results in a completely tits-up machine.  CPU stuck somewhere
> spinning with local interrutps disabled.
> 
> If you see the log output I sent, I'm suspecting this might be because

I don't. :(

> this BSG brainfart has exposed underlying bugs in IDE or SCSI.

Possible but ATM I have an (overdue) IDE update to push, people waiting for
(overdue) patches to try and some (overdue) patches to finish and post...

Would be great if somebody beats me to investigate this issue.

Hint: this would be a great way to redempt pushing buggy commit behind
my back. ;-)

Thanks,
Bart
