Return-Path: <linux-kernel-owner+w=401wt.eu-S1763838AbYGABew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763838AbYGABew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYGABeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:34:44 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:57776 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYGABen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:34:43 -0400
Date: Tue, 1 Jul 2008 11:34:38 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30 - powerpc - build failure at arch_add_memory()
Message-ID: <20080701013438.GT20457@bakeyournoodle.com>
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <486924FE.4090801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <486924FE.4090801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 11:55:02PM +0530, Kamalesh Babulal wrote:
> Hi Stephen,
> 
> next-20080630 kernel build fails on powerpc, with randconfig
> 
>   CC      arch/powerpc/mm/mem.o
> arch/powerpc/mm/mem.c: In function ‘arch_add_memory’:
> arch/powerpc/mm/mem.c:130: error: implicit declaration of function ‘create_section_mapping’
> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
> make: *** [arch/powerpc/mm] Error 2

This problem exists in in 2.6.26-rc8, so it's not specifially linux-next
realted.  The patch at:
http://patchwork.ozlabs.org/linuxppc/patch?id=19347
should fix it but is un-ACK'd ;P

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

