Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYL2UtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYL2UtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYL2Usu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:48:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbYL2Ust (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:48:49 -0500
Date: Mon, 29 Dec 2008 12:47:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] exofs: dir_inode and directory operations
Message-Id: <20081229124759.d21e1410.akpm@linux-foundation.org>
In-Reply-To: <4947C939.6030006@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947C939.6030006@panasas.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 17:28:57 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> implementation of directory and inode operations.
> 
> * A directory is treated as a file, and essentially contains a list
>   of <file name, inode #> pairs for files that are found in that
>   directory. The object IDs correspond to the files' inode numbers
>   and are allocated using a 64bit incrementing global counter.
> * Each file's control block (AKA on-disk inode) is stored in its
>   object's attributes. This applies to both regular files and other
>   types (directories, device files, symlinks, etc.).
> 
> ...
>
>  fs/exofs/dir.c   |  649 ++++++++++++++++++++++++++++++++++++++++++++++++++++++

yes, this does look rather ext2-like ;)

How long ago was the code cloned from ext2?  iirc there have been a
number of fairly subtle bugs fixed in ext2/dir.c over the past year or
three.  If the code was not quite recently cloned then I'd suggest that
you spend a bit of time looking through the ext2 changelogs, see if
there are any bugfixes which needs to be ported.


