Return-Path: <linux-kernel-owner+w=401wt.eu-S2993490AbXEBQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993490AbXEBQjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993508AbXEBQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:39:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:42307 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993490AbXEBQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PNpsgI/Y6BCZ1hJyQA4PgZQBdvfe1Uyh3ENFPw+GhPqRmhotygTBkwka1rUH+W2vnp23BlcTrPAykf7uSrRM6KAzeC8/IL7LZXTRN3taQ8uGy5CF2lSoRpt/gppJyMkW1q9oBkIHtKpmDRa0NsMQDiVKnwW6gO5uLi0Y6k2Jb4U=
Message-ID: <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
Date: Wed, 2 May 2007 09:39:39 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070502104936.674a4b54.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> I understand your concerns, but *this* patch bundle extends poll()/select()/epoll, and is not an alternative to kevent or other work in progress, (and linux centered)

It is adding huge amounts of complexity and at the same time is not
future-safe.  I consider this enough reason to reject this approach.
You never can get rid of the interface.  It's much cleaner and safer
to do it right instead of piling on more and more workarounds for
special situations.
