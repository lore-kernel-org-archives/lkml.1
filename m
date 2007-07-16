Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbXGPRX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbXGPRX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXGPRXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:23:50 -0400
Received: from [212.12.190.32] ([212.12.190.32]:32992 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751984AbXGPRXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:23:49 -0400
X-Greylist: delayed 10848 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 13:23:47 EDT
From: Al Boldi <a1426z@gawab.com>
To: =?utf-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: Hardlink Pitfalls (was: Patches for REALLY TINY 386 kernels)
Date: Mon, 16 Jul 2007 20:23:04 +0300
User-Agent: KMail/1.5
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200707161722.53203.a1426z@gawab.com> <a781481a0707160944h2f991739p69058208cdf13f76@mail.gmail.com> <20070716165312.GA32647@lazybastard.org>
In-Reply-To: <20070716165312.GA32647@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707162023.04646.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Mon, 16 July 2007 22:14:41 +0530, Satyam Sharma wrote:
> > On 7/16/07, Al Boldi <a1426z@gawab.com> wrote:
> > >Satyam Sharma wrote:
> > >> Or just "cp -al" to create multiple trees at (almost) no disk cost
> > >> that won't interfere with each other in any way, and makes the
> > >> development process / generating patchsets trifle easier as well ...
> > >
> > >That would be correct if hardlinks would actually do a CoW on modify,
> > >instead
> > >of misleading the user into thinking he is modifying an independent
> > > file.
> >
> > "patch" already handles this correctly ... and
> > backupcopy=auto,breakhardlink in vim (and something similar in other
> > editors I presume)
>
> Yet even a single program failing to break the link will leave you with
> a mess to sort out.

No kidding!

> The only place that can ensure to always break the
> link is the kernel.  Which is why I wrote the cowlink patches some years
> back.

Can you post a patch against 2.6.22?

> The still need a lot of love to be merge-ready.  But I do use them on a
> daily basis.

Well, if the patch is lean and optional and runtime configurable, then they 
should definitely be considered for inclusion.


Thanks!

--
Al

