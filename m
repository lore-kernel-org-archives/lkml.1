Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXIPTjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXIPTjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXIPTjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:39:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbXIPTjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:39:40 -0400
Date: Sun, 16 Sep 2007 12:39:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Jeff Layton" <jlayton@redhat.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: iunique() fails to return ino_t (after commit 866b04fccbf125cd)
Message-Id: <20070916123912.6cf3ceb7.akpm@linux-foundation.org>
In-Reply-To: <a781481a0709161228t216322dcq5dfd60062bb825be@mail.gmail.com>
References: <a781481a0709161228t216322dcq5dfd60062bb825be@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 00:58:54 +0530 "Satyam Sharma" <satyam.sharma@gmail.com> wrote:

> [*] BTW, the changelog/patch description of this commit demonstrates
> why it is a Bad Thing (tm) to have lengthy [PATCH 0/x] kind of mails
> (containing important technical details) preceding a patchset.
> 
> I can only guess as to what happened, but reading the archives of the
> original submission of this patchset on LKML, I think Andrew had to
> append the contents of the [0/3] mail to the git commit of the [1/3]
> patch (so as to not lose all those details and ensure that they got saved
> in the git history), with the result that most of the changelog of commit
> 866b04fccbf1 has nothing to do with that particular patch at all, but
> instead with other commits, that do not even touch that same file (!)
> 
> So guys, please keep "[0/x]" mails short and only as a non-technical
> introduction of the patchset. All relevant discussion must come in the
> other mails that contain the *real* patches.

yup.

Actually, when I do the copying of the [0/n] text into [1/n]'s changelog
I could add text to the changelogs of [2/n] ... [n/n] mentioning that
more details are in the preceding changelog.
