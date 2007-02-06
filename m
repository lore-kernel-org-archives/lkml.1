Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXBFWJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXBFWJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXBFWJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:09:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965527AbXBFWJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:09:42 -0500
Date: Tue, 6 Feb 2007 14:09:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Tomasz Kvarsin" <kvarsin@gmail.com>
Cc: viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: warrning fix: unsigned->signed
Message-Id: <20070206140936.24bbaded.akpm@linux-foundation.org>
In-Reply-To: <5157576d0702061339w28adbf5fp2dbc5e86661d894@mail.gmail.com>
References: <5157576d0702061339w28adbf5fp2dbc5e86661d894@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 00:39:45 +0300
"Tomasz Kvarsin" <kvarsin@gmail.com> wrote:

> While compiling my code, I always get bunch of warrning from headers,
> here is fix for them:
> __getblk is alawys called with unsigned argument,
> but it takes signed, the same story with __bread,__breadahead and so on.

The patch seems OK, but I'm curious to know why you're seeing this warning
and nobody else is.  Are you using a compiler other than gcc?  If gcc,
which version?  Did you add any new compiler options?

Thanks.
