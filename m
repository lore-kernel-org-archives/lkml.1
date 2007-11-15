Return-Path: <linux-kernel-owner+w=401wt.eu-S933653AbXKOVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933653AbXKOVgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933535AbXKOVfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:35:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56016 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933523AbXKOVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:35:32 -0500
Date: Thu, 15 Nov 2007 13:34:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: jblunck@suse.de, linux-kernel@vger.kernel.org, bfields@fieldses.org,
       trond.myklebust@fys.uio.no
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071115133458.967ca5d7.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<64bb37e0711141116h5ea9ed8cs7f2afbabe73f07bb@mail.gmail.com>
	<20071114122939.7b4ee194.akpm@linux-foundation.org>
	<64bb37e0711141448h15c667dbn4496870dd64a0457@mail.gmail.com>
	<20071115173627.GG25521@hasse.suse.de>
	<64bb37e0711151324k2a10e683k506c50126ad1978f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 22:24:12 +0100
"Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> The problem with the first bisect-try was, that everything between
> bisect-good: r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename
> and
> bisect-bad: use-struct-path-in-struct-svc_export
> did not compile like this:
> 
>   CC [M]  fs/nfsd/vfs.o
> fs/nfsd/vfs.c: In function 'nfsd_rename':
> fs/nfsd/vfs.c:1695: error: request for member 'mnt' in something not a
> structure or union

argh.  I'd incorrectly worked out that
nfsd-fix-wrong-mnt_writer-count-in-rename.patch was a fix against
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch however
it is in fact a fix against use-struct-path-in-struct-svc_export.patch.

My life sucks.  
