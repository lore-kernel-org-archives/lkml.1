Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYFMHRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYFMHRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 03:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYFMHRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 03:17:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556AbYFMHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 03:17:09 -0400
Date: Fri, 13 Jun 2008 00:16:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575!
Message-Id: <20080613001644.b1b87b0e.akpm@linux-foundation.org>
In-Reply-To: <4041.1213330723@turing-police.cc.vt.edu>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
	<4850E1E5.90806@linux.vnet.ibm.com>
	<4041.1213330723@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 00:18:43 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 12 Jun 2008 14:14:21 +0530, Kamalesh Babulal said:
> > Hi Andrew,
> > 
> > 2.6.26-rc5-mm3 kernel panics while booting up on the x86_64
> > machine. Sorry the console is bit overwritten for the first few lines.
> 
> > no fstab.kernel BUG at mm/filemap.c:575!
> 
> For whatever it's worth, I'm seeing the same thing on my x86_64 laptop.
> -rc5-mm2 works OK, I'm going to try to bisect it tonight.

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm3/hot-fixes/fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch is said to "fix" it.

