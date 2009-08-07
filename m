Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZHGCZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZHGCZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZHGCZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:25:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbZHGCZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:25:32 -0400
Date: Thu, 6 Aug 2009 19:25:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <damm@igel.co.jp>,
       Paul Mundt <lethal@linux-sh.org>, David Woodhouse <dwmw2@infradead.org>,
       linux-mtd@lists.infradead.org
Subject: Re: mmotm 2009-08-06-00-30 uploaded (mtd)
Message-Id: <20090806192513.53f6488b.akpm@linux-foundation.org>
In-Reply-To: <20090806190233.6d4b4e28.randy.dunlap@oracle.com>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	<20090806190233.6d4b4e28.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Aug 2009 19:02:33 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Thu, 06 Aug 2009 00:33:06 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-08-06-00-30 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.31-rc5:
> 
> 
> 
> drivers/built-in.o: In function `generic_onenand_remove':
> generic.c:(.devexit.text+0x1b8e): undefined reference to `del_mtd_partitions'
> 
> config attached.

Thanks.  It's mtd-make-onenand-genericc-more-generic.patch.

There's a bit of a bunfight happening over on linux-mtd but I'll hang
onto the patch for now.

