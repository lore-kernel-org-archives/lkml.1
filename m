Return-Path: <linux-kernel-owner+w=401wt.eu-S1161873AbXECNk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161873AbXECNk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161875AbXECNk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:40:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:36849 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161873AbXECNk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y9omIXkJM3I3BPQ55UcjlDCHbnej0xkhcloNXps3mTRNifK9yS9XkD9j59iMAvycPzgMl0GskftnjuUxuvD98LPOofSM6uj4VHUyNzOvQtnN2KGqwr5HsF3a9m/tlKGt3dj6AAuW9XLPENFweoft5iGRJm6GrEniNDBLt9cixKQ=
Message-ID: <a36005b50705030640t1169c2d0g1c6cf9d5ec9a9d36@mail.gmail.com>
Date: Thu, 3 May 2007 06:40:54 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4638D2FE.3060706@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
	 <4638C37D.7050503@haxent.com.br>
	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
	 <4638CC6D.6080505@haxent.com.br>
	 <a36005b50705021049k44881c5er1b9e61d64618ae1e@mail.gmail.com>
	 <4638D2FE.3060706@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
> The usage cases of yours are quite different from mine. We don't use a
> single file descriptor to to manage various resources. The worker threads
> are _not going_ to have a file descriptor, _only_ the event dispatching
> (poll)
> thread.

An model which doesn't scale well.


> A pollable futex is even more useful for _single_ threaded programs that
> don't want to go into lengthy hacks to monitor events coming from the
> outside
> world.

There is nothing here that cannot be done with a more complete model
for event handling.  It's Linus decision whether he wants to add yet
more code, yet more possible problems, yet more maintenance
overhead/nightmare for an interim solution which isn't necessary,
which cannot solve all the problems, and which is not as scalable as
other proposed methods.

I can only say that I would be trickly against it.  It makes just no sense.
