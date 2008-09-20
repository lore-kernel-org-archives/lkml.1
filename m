Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbYITEuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbYITEuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 00:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYITEuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 00:50:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:59426 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYITEuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 00:50:09 -0400
Date: Fri, 19 Sep 2008 21:50:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fastboot: fix mismerged conflict in init/main.c
Message-ID: <20080919215014.37e2196d@infradead.org>
In-Reply-To: <20080919194215.12fe4c75@infradead.org>
References: <20080919194215.12fe4c75@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 19:42:15 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> 
> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] fastboot: fix mismerged conflict in init/main.c

ok turns out it was a real conflict, not a mismerge. I've just fixed it
and pushed out my git tree.

The following changes since commit
77e9695b9d5c9ce761dedc193045d9cb64b8e245: Arjan van de Ven (1):
        Add a script to visualize the kernel boot process / time

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git
master

Arjan van de Ven (2):
      fastboot: fix issues and improve output of bootgraph.pl
      use the fancy new printk flags to print the function pointer

Arnaud Patard (1):
      fastboot: Fix bootgraph.pl initcall name regexp

 init/main.c          |    8 +++-----
 scripts/bootgraph.pl |   33 +++++++++++++++++++++------------
 2 files changed, 24 insertions(+), 17 deletions(-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
