Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbZJMHzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbZJMHzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbZJMHzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:55:49 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45709 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbZJMHzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:55:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XUXyy0l+v4/lzxELGHeLPjyFUdX+GWim5njZdEHvFrA++NW5/qyh3F56PzbfSoOETf
         l+uuSwxuHKSMs0itbmAowiWVuFnVQlXTsWY9VWZcxvoyGHpBSinAEVFto8ypUtKLhHZ2
         OqhtwXITqDxDTxUIpJWHa6OM+ogjeSO9Ehu9M=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> 
	<alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 13 Oct 2009 03:54:52 -0400
Message-ID: <8bd0f97a0910130054v43fd9fbcv5316a5194ced4bfc@mail.gmail.com>
Subject: Re: [PATCH 1/6 RFC] arch/blackfin/kernel/process.c: Remove the BKL 
	from sys_execve
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 18:33, John Kacur wrote:
> This looks like a cut-and-paste job.
> For example, compare this function to sys_execve in
> arch/x86/kernel/process_64.c
>
> and it is almost line by line the same, except the one in x86 nolonger has the
> big kernel lock. All of the functions called between the lock are generic
> and not specific to blackfin - thus, I believe it is safe to remove the
> bkl here.

and it still boots/runs fine, so np here
Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
