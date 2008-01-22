Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYAVBei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYAVBei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYAVBeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:34:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:52386 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYAVBea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wa2gvTOZu+0eJM9vHFUz7LMo//mEGRnt2HGbZKMaxcKKQl13qiMfB8sW/ntka7Glq5FOSUTHAI36AIJjstdT5FuswKPT3we94SYnVg1Ke+tHROQnEDy2vPL4fnibtKO+ToSSdCYvG/suhPrwlWjCgz0ixFJEKqUDJ/D+Efby6ME=
Message-ID: <9a8748490801211734w7fbb0ed9i66d63153c870a3f0@mail.gmail.com>
Date: Tue, 22 Jan 2008 02:34:29 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Subject: Re: [PATCH -v7 0/2] Fixing the issue with memory-mapped file times
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com,
       miklos@szeredi.hu, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <12009619562023-git-send-email-salikhmetov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> This is the seventh version of my solution for the bug #2645:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=2645
>
> Since the previous version, the following has changed: based on
> Linus' comment, SMP-safe PTE update implemented.
>
> Discussions, which followed my past submissions, showed that it was
> tempting to approach this problem using very different assumptions.
> However, many such designs have proved to be incomplete or inefficient.
>
> Taking into account the obvious complexity of this problem, I prepared a
> design document, the purpose of which is twofold. First, it summarizes
> previous attempts to resolve the ctime/mtime issue. Second, it attempts
> to prove that what the patches do is necessary and sufficient for mtime
> and ctime update provided that we start from a certain sane set of
> requirements. The design document is available via the following link:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=2645#c40
>
> For the seventh version, comprehensive performance testing was performed.
> The results of performance tests, including numbers, are available here:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=2645#c43
>

Hi Anton,

I applied your patches here and as far as my own test programs go,
these patches solve the previously observed problems I saw with mtime
not getting updated.

Thank you very much for so persistently working on these long standing issues.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
