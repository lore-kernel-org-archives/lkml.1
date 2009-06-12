Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZFLN5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZFLN5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763411AbZFLN5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:57:07 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:43048 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763008AbZFLN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gKXo+1JzzUPuGMNPI99ol3fEHHF+NYNo4dFbjStHhgXfUx9Ehpfbwqywy0RjFeMbTL
         6MJt2kv69Lpr6dG5vlFbOpg710gGd5xWRTp/K1b4CnWeKwEpCOz1fQXCyYjeZFVzuCPc
         fdHOiFBdS5jU0BGozGJMOESs+Z25pWu7A4OCg=
MIME-Version: 1.0
In-Reply-To: <20090612132443.GA24002@damson.ad.medicalresearch.no>
References: <20090612132443.GA24002@damson.ad.medicalresearch.no>
Date: Fri, 12 Jun 2009 16:57:04 +0300
X-Google-Sender-Auth: dd64fe3a7815a90a
Message-ID: <84144f020906120657j31fb3e82t2da251d31db6ba92@mail.gmail.com>
Subject: Re: [GIT PULL] kmemcheck for mainline
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Jun 12, 2009 at 4:31 PM, Vegard Nossum<vegard.nossum@gmail.com> wrote:
> Please consider pulling the kmemcheck tree;
>
> kmemcheck is a feature which can (at run-time) detect some uses of
> uninitialized memory within the kernel, similarly to what Valgrind's memcheck
> does for userspace programs. We also have the ability to find use-after-free
> errors and leaks of uninitialized data to userspace, both with a false-
> positive rate of zero.
>
> kmemcheck is self-contained in the sense that when CONFIG_KMEMCHECK=n, it has
> no effect on the compiled kernel whatsoever. Our code has lived in the -tip
> tree and been in -next for over a year, and has the acks of x86 and slab
> maintainers (Ingo and Pekka). Inclusion in mainline would lower the threshold
> for building and running kmemcheck-enabled kernels, which would also
> hopefully increase testing coverage of the rest of the kernel code.

I hope I didn't burn all my karma for this merge window with the slab
early boot patches but:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

for this pull request.

                                      Pekka
