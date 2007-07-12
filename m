Return-Path: <linux-kernel-owner+w=401wt.eu-S1763909AbXGLMht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763909AbXGLMht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXGLMhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:37:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30359 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbXGLMhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qS6q4uSU0ORFJ1lAE66S7pQvW1imdgMpNXzSNEAUPr2m2PVXU7nk4XRHrbWTZ32SBNDDslzh9oQo6dY7dwXpOJ80sWx6FgVsoU5s8ZJZLBuYIj+5AmMXHsQiqtc0uUK+hmb/2hMg4Xq9f/Bqr2J7yhxgPnBVVblVf0gPcFiuJOM=
Message-ID: <a9e22dff0707120537l1a29de93vdd67f146cf36a120@mail.gmail.com>
Date: Thu, 12 Jul 2007 15:37:39 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: davids@webmaster.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NPTL
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707120518t77d440d3ue0368fd1f3e36c03@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKCEOCFDAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So I can say that in linux 'thread' == 'process'?

Is kernel routine 'kthread' creating a process?
I'm just thinking on this subject: if to create 'real threads' - will
it increase performance? Should I ever think in this way?
When I say 'real thread' - I mean the thread that doen't switch
context when it's starting to run.

On 7/12/07, David Schwartz <davids@webmaster.com> wrote:
>
> > Hi!
> > I have a question about NPTL.
> > Are NPTL are still based on `clone` system call?
>
> Yes.
>
> > Are NPTL threads are
> > "processes" internally?
>
> No. By definition, all the threads belong to a single process. NPTL threads
> are based on KSEs (kernel scheduling entities). A non-threaded process is
> also a KSE. A threaded process is more than one KSEs. All KSE are,
> obviously, scheduled by the kernel.
>
> > Thanks!
>
> You're welcome.
>
> DS
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
