Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbYENGv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbYENGv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYENGvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:51:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56623 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbYENGvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:51:20 -0400
Date: Wed, 14 May 2008 08:51:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, acme@redhat.com, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, Pekka Paalanen <pq@iki.fi>,
       Pavel Roskin <proski@gnu.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/2]: Add sparc64 ftrace support.
Message-ID: <20080514065156.GA3159@uranus.ravnborg.org>
References: <20080513.220652.24245811.davem@davemloft.net> <20080514063055.GA21369@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514063055.GA21369@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> [ also a patch integration detail: i took the liberty to move your 
>   arch/sparc64/Kconfig's HAVE_FTRACE to the first spot of the SPARC64 
>   select lines as per the second patch below - your patch had a conflict 
>   against current mainline (which probably means you already changed 
>   this file in your Sparc64 tree). By moving that entry to the first 
>   line your tree and the ftrace tree should auto-merge just fine without 
>   any conflicts. ]

When adding new select entries I try to keep them sorted alphabetically.
It will not solve all the merge issues but as the list grows this should
help. At least betterthan adding to the end.

	Sam
