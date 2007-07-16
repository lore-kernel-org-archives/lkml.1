Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbXGPQ47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbXGPQ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbXGPQ4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:56:49 -0400
Received: from lazybastard.de ([212.112.238.170]:49562 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbXGPQ4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:56:48 -0400
Date: Mon, 16 Jul 2007 18:53:12 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Hardlink Pitfalls (was: Patches for REALLY TINY 386 kernels)
Message-ID: <20070716165312.GA32647@lazybastard.org>
References: <200707161722.53203.a1426z@gawab.com> <a781481a0707160944h2f991739p69058208cdf13f76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a781481a0707160944h2f991739p69058208cdf13f76@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 July 2007 22:14:41 +0530, Satyam Sharma wrote:
> On 7/16/07, Al Boldi <a1426z@gawab.com> wrote:
> >Satyam Sharma wrote:
> >> Or just "cp -al" to create multiple trees at (almost) no disk cost
> >> that won't interfere with each other in any way, and makes the
> >> development process / generating patchsets trifle easier as well ...
> >
> >That would be correct if hardlinks would actually do a CoW on modify, 
> >instead
> >of misleading the user into thinking he is modifying an independent file.
> 
> "patch" already handles this correctly ... and backupcopy=auto,breakhardlink
> in vim (and something similar in other editors I presume)

Yet even a single program failing to break the link will leave you with
a mess to sort out.  The only place that can ensure to always break the
link is the kernel.  Which is why I wrote the cowlink patches some years
back.

The still need a lot of love to be merge-ready.  But I do use them on a
daily basis.

Jörn

-- 
Joern's library part 2:
http://www.art.net/~hopkins/Don/unix-haters/tirix/embarrassing-memo.html
