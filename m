Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZBXCxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZBXCxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 21:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZBXCwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 21:52:54 -0500
Received: from ozlabs.org ([203.10.76.45]:40272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZBXCwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 21:52:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Date: Tue, 24 Feb 2009 13:22:45 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <499E16D5.9070106@kernel.org> <20090219190417.c664bff4.akpm@linux-foundation.org>
In-Reply-To: <20090219190417.c664bff4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902241322.46275.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 February 2009 13:34:17 Andrew Morton wrote:
> It's a dumb convention.

I disagree, but it doesn't matter.  Least surprise wins; let's not make
kernel coding any harder than it has to be.

free() does it, so kfree() should do it.  Otherwise call it something
completely different.  Too late, let's move on...

> In the vast majority of cases the pointer is
> not NULL.  We add a test-n-branch to 99.999999999% of cases just to
> save three seconds of programmer effort a single time.

It's unusual, but since I've used it several times in the kernel myself,
it's less than 4 9s (by call sites not by usage, since it tends to be
error paths).

> (We can still do that by adding a new
> kfree_im_not_stupid() which doesn't do the check).

Now you're insulting people who use it as well as exaggerating your case.

Do you need a hug?
Rusty.
