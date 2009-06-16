Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbZFPQWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbZFPQWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZFPQV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:21:57 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59156 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbZFPQV5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sH2/04o/hiEXW7wfR7czHzeLRxw8b1ikoLNMQyEHjjrxcivUTFs/L58Y7IoZgiBOJP
         +AzRhzelJ9WhRkuS5eK+XMWvFFl5naFI+Ksq1R0mG4Ka3WqNsMbKMh4YGTDsar4NzNhG
         xb4I9c+Mu498RLd0pQ3F022bjdw7v0L0m/e2E=
MIME-Version: 1.0
In-Reply-To: <20090615145933.GA26856@damson.getinternet.no>
References: <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
	 <20090615145933.GA26856@damson.getinternet.no>
Date: Tue, 16 Jun 2009 19:21:57 +0300
X-Google-Sender-Auth: e9d94a6a5a76270e
Message-ID: <84144f020906160921s234b0095k654c75e2e6bfe6dd@mail.gmail.com>
Subject: Re: [GIT PULL] kmemcheck for mainline
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 5:59 PM, Vegard Nossum<vegard.nossum@gmail.com> wrote:
> I redid the tree by rebasing. I've backported and incorporated fixes except
> in the (few) cases where multiple authors were involved, in order to preserve
> authorship information. I rebased against the same version that the previous
> pull request was merged to; this allows us to easily view the difference
> between the two pull requests (minus the top commit, which is a merge with
> your latest tree):
>
>  $ git diff kmemcheck/for-linus..kmemcheck/for-linus2^
>
> and account for any discrepancies (see the bottom of this e-mail). I've
> tested the new tree on x86 and x86_64 with and without kmemcheck.

Looks good to me. Ingo, if Linus doesn't pull this for -rc1, I think
you should nuke the kmemcheck branch in -tip and use this instead,
right?

                                Pekka
