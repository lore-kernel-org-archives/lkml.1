Return-Path: <linux-kernel-owner+w=401wt.eu-S935150AbXGTTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935150AbXGTTr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763029AbXGTTrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 15:47:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbXGTTrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 15:47:40 -0400
Date: Fri, 20 Jul 2007 15:47:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Douglas Thompson <dougthompson@xmission.com>
Subject: Re: drivers/edac: add mips and ppc visibility
Message-ID: <20070720194737.GA30184@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Douglas Thompson <dougthompson@xmission.com>
References: <200707191759.l6JHxG4c022643@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707191759.l6JHxG4c022643@hera.kernel.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 05:59:16PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b113a3f7e85d7f97c8383a88a5bc7c2ea8daeb2f
 > Commit:     b113a3f7e85d7f97c8383a88a5bc7c2ea8daeb2f
 > Parent:     052dfb45ccb5ea354a426b52556bcfee75b9d2f5
 > Author:     Douglas Thompson <dougthompson@xmission.com>
 > AuthorDate: Thu Jul 19 01:50:15 2007 -0700
 > Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
 > CommitDate: Thu Jul 19 10:04:55 2007 -0700
 > 
 >     drivers/edac: add mips and ppc visibility
 >     
 >     1) Remove an old CVS ID string
 >     
 >     2) change EDAC from a tristate option to a simple bool option
 >     
 >     3) In addition to the X86 arch, PPC and MIPS also have drivers in the
 >     submission queue.  This patch turns on the EDAC flag for those archs.  Each
 >     driver will have its respective 'depends on ARCH' set.
 >     
 >     Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
 >     Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
 >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

What was the reasoning behind 2) ?
Now everyone's distro kernel has bits of EDAC in it even if they
don't use it.  (Admittedly only a small amount, but these things
tend to creep in bit by bit).

	Dave

-- 
http://www.codemonkey.org.uk
