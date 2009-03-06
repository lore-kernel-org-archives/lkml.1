Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZCFPOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZCFPOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZCFPOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:14:22 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:47460 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbZCFPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:14:21 -0500
X-Greylist: delayed 2179 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2009 10:14:21 EST
Date: Fri, 6 Mar 2009 09:35:43 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Am??rico Wang <xiyou.wangcong@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Rob Landley <rob@landley.net>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ARCH=um segfault on x86-64.
Message-ID: <20090306143543.GA6983@c2.user-mode-linux.org>
References: <200903060042.19084.rob@landley.net> <20090306084848.GO22605@hack.private> <10f740e80903060150p565e9703u81d4fe47cb599ab@mail.gmail.com> <10f740e80903060151w779bbd11ld2fcc437ac7ac321@mail.gmail.com> <20090306111834.GC8991@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306111834.GC8991@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 07:18:34PM +0800, Am??rico Wang wrote:
> It does work well x86_64, but my question is that whether this will
> break i386 or not, since before, CONFIG_3_LEVEL_PGTABLES depends on
> EXPERIMENTAL on i386, this patch removes it.

As long as CONFIG_3_LEVEL_PGTABLES is off on 32-bit, it should be fine.

It did work, last I checked, but 3-level page tables on 32-bit is a
very rarely used combination, and not useful.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
