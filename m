Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXCZL6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXCZL6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXCZL6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:58:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXCZL6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:58:54 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070326035027.c522cdf5.akpm@linux-foundation.org> 
References: <20070326035027.c522cdf5.akpm@linux-foundation.org>  <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 12:58:42 +0100
Message-ID: <7465.1174910322@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I'll touch up the changelog for nommu-hide-vm_mm-in-nommu-mode.patch and then
> I'll temporarily drop it so the blackfin guys can test their work, I guess.

Thanks.

As I said, I'm also not sure that revocation of VMAs is supportable on NOMMU,
so the thing to do may be to hide it entirely if CONFIG_MMU=n.

David
