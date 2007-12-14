Return-Path: <linux-kernel-owner+w=401wt.eu-S933795AbXLNQc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbXLNQc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXLNQcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:32:50 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21890 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXLNQct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:32:49 -0500
Message-ID: <4762B02E.7030102@msgid.tls.msk.ru>
Date: Fri, 14 Dec 2007 19:32:46 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org,
       Jim Kissel <jlk@osml.eu>
Subject: Re: [PATCH 2/2] Unionfs: clarify usage.txt mount options
References: <11976472813872-git-send-email-ezk@cs.sunysb.edu> <11976472822359-git-send-email-ezk@cs.sunysb.edu>
In-Reply-To: <11976472822359-git-send-email-ezk@cs.sunysb.edu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:

> --- a/Documentation/filesystems/unionfs/usage.txt
> +++ b/Documentation/filesystems/unionfs/usage.txt
[]
> +OPTIONS can be any legal combination one of:
                                       ^^^^^
A small typo.

> +
> +- ro		# mount file system read-only
> +- rw		# mount file system read-write
> +- remount	# remount the file system (see Branch Management below)
> +- incgen	# increment generation no. (see Cache Consistency below)
> +
> +BRANCH-OPTIONS can be either (1) a list of branches given to the "dirs="
> +option, or (2) a list of individual branch manipulation commands, described
> +in the "Branch Management" section below.

Should this (2) choice mention remount operation somehow?
It seems the (2) case is about remount only.

> +The "dirs=" option takes a colon-delimited list of directories to compose
> +the union, with an optional branch mode for each of those directories.
> +Directories that come earlier (specified first, on the left) in the list
> +have a higher precedence than those which come later.  Additionally,

By the way, what is "precedence" here?  I mean, will unionfs always
write to the first rw branch, or is it possible to write to some
deeper branch too?

And finally, can a first (and all of them as well) branch be ro?

Thanks.

/mjt
