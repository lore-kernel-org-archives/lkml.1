Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbZERJKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbZERJKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZERJJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:09:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34127 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbZERJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:09:43 -0400
X-IronPort-AV: E=Sophos;i="4.41,208,1241409600"; 
   d="scan'208";a="51614390"
Subject: Re: [PATCH] Fix print out of function which called WARN_ON()
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <ak@linux.intel.com>, Jakub Jelinek <jakub@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
References: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>
	 <alpine.LFD.2.01.0905151018370.3343@localhost.localdomain>
	 <4A0DC797.7040502@linux.intel.com>
	 <alpine.LFD.2.01.0905161342150.3301@localhost.localdomain>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 18 May 2009 10:09:38 +0100
Message-ID: <1242637778.20731.7.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-16 at 13:47 -0700, Linus Torvalds wrote:

>  - it uses '%pS' instead of of sprint_symbol
[...]
> -       printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
> -               line, function);
> +	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);

Those parens end up looking pretty odd to me with the %pS:
	WARNING: at [...] local_bh_enable+0x68/0x80()

Otherwise it works fine, thanks.

Ian.


