Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbYIAU3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbYIAU3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbYIAU3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:29:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:47672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759383AbYIAU3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:29:05 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18lNUhl+iAlNYGKdWL4/KkQZnlKfeisBVM9LyqnSF
	X4dTnWPgJne/Q3
Message-ID: <48BC508A.8000506@gmx.de>
Date: Mon, 01 Sep 2008 22:28:58 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Al Viro <viro@zeniv.linux.org.uk>, Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix typo in arch/parisc/hpux/fs.c
References: <20080902034327.2c66cda5.sfr@canb.auug.org.au>
In-Reply-To: <20080902034327.2c66cda5.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> A parisc allmodconfig build produces this:
> 
> arch/parisc/hpux/fs.c:107: error: 'buffer' undeclared (first use in this function)
> 
> Introduced by commit da574983de9f9283ba35662c8723627096e160de ("[PATCH]
> fix hpux_getdents()").
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Thanks Stephen.
The same bug/patch is already tracked in bugzilla 11461:

Rafael J. Wysocki wrote:
 > This message has been generated automatically as a part of a report
 > of recent regressions.
 >
 > The following bug entry is on the current list of known regressions
 > from 2.6.26.  Please verify if it still should be listed and let me know
 > (either way).
 >
 >
 > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11461
 > Subject		: build breakage
 > Submitter	: Helge Deller <deller@gmx.de>
 > Date		: 2008-08-30 10:34 (1 days old)
 > References	: http://marc.info/?l=linux-kernel&m=122009254918593&w=4
 > Handled-By	: Helge Deller <deller@gmx.de>
 > Patch		: http://marc.info/?l=linux-kernel&m=122009254918593&w=4
