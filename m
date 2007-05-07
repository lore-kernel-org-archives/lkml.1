Return-Path: <linux-kernel-owner+w=401wt.eu-S966337AbXEGTel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966337AbXEGTel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966259AbXEGTej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:34:39 -0400
Received: from [212.12.190.137] ([212.12.190.137]:32972 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966317AbXEGTei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:34:38 -0400
From: Al Boldi <a1426z@gawab.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Execute in place
Date: Mon, 7 May 2007 22:37:33 +0300
User-Agent: KMail/1.5
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200705030211.36293.a1426z@gawab.com> <200705031433.09364.a1426z@gawab.com> <463F57CB.4090301@zytor.com>
In-Reply-To: <463F57CB.4090301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072237.33217.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Al Boldi wrote:
> > Isn't everything really just temporary?
> >
> > Would something like an mmap'd tmpfs be possible?
>
> No.  tmpfs relies on being able to leave data structures in the running
> kernel.  In particular, it has no metadata store at all.
>
> The needs for a persistent filesystem are very different, regardless of
> what the underlying medium is.

Think Suspend-To-Disk; in that case tmpfs looks pretty persistent to me.

So what does STD do?  It pushes memory out to swap.

Now, tmpfs could probably do the same thing on its own either to a private 
swap or an mmap.  I am suggesting mmap, as swap is currently really slow 
with tmpfs, and switching it to use mmap may buy us 2 for the price of 1.


Thanks!

--
Al

