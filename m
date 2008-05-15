Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbYEOABm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbYEOABm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYEOABd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:01:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbYEOABc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:01:32 -0400
Date: Wed, 14 May 2008 17:00:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: reiserfs BUG in 2.6.26-rc2-mm1
Message-Id: <20080514170054.56deb9df.akpm@linux-foundation.org>
In-Reply-To: <482B7AC0.2050800@oracle.com>
References: <482B7AC0.2050800@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 16:50:24 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> This is blocksize=1024 bytes, data=ordered.
> 
> On x86_64.
> 
> ------------[ cut here ]------------
> kernel BUG at fs/reiserfs/journal.c:1414!

yup, Jeff had a whoopsie.  Should be mended by
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/hot-fixes/reiserfs-convert-j_flush_sem-to-mutex-fix.patch
