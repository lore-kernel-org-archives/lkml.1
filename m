Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXHaEeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXHaEeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXHaEeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:34:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751769AbXHaEeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:34:14 -0400
Date: Thu, 30 Aug 2007 21:33:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Alexey Dobriyan <adobriyan@sw.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Len Brown <lenb@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix maxcpus=1 oops in show_stat()
In-Reply-To: <Pine.LNX.4.64.0708310404210.4873@blonde.wat.veritas.com>
Message-ID: <alpine.LFD.0.999.0708302132470.25853@woody.linux-foundation.org>
References: <20070828111431.GA27707@localhost.sw.ru>
 <Pine.LNX.4.64.0708290546430.31816@blonde.wat.veritas.com>
 <20070829052331.GB1765@martell.zuzino.mipt.ru> <200708290241.36092.lenb@kernel.org>
 <20070829072508.GA2707@localhost.sw.ru>
 <Pine.LNX.4.64.0708310404210.4873@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 31 Aug 2007, Hugh Dickins wrote:
>
> So stay safe for now and just revert those #ifndef CONFIG_HOTPLUG_CPU
> optimizations in rc1's commit.

Thanks for the debugging, applied.

		Linus
