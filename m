Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXC0Apk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXC0Apk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 20:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933863AbXC0Apk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 20:45:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933853AbXC0Apj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 20:45:39 -0400
Date: Mon, 26 Mar 2007 17:45:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
Message-Id: <20070326174535.4f21bed3.akpm@linux-foundation.org>
In-Reply-To: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 23:04:09 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> This patch adds support for finding out the current file position,
> open flags and possibly other info in the future.

fs/proc/base.c: In function 'proc_lookupfdinfo':
fs/proc/base.c:1584: warning: passing argument 3 of 'proc_lookupfd_common' from incompatible pointer type
fs/proc/base.c: In function 'proc_readfdinfo':
fs/proc/base.c:1590: warning: passing argument 4 of 'proc_readfd_common' from incompatible pointer type

If taken, that callback into proc_lookupfd_common() will crash the kernel.
