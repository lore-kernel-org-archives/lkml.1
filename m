Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbXFFNCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbXFFNCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 09:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764723AbXFFNCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 09:02:42 -0400
Received: from [198.99.130.12] ([198.99.130.12]:55965 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1762162AbXFFNCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 09:02:41 -0400
Date: Wed, 6 Jun 2007 08:52:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other woes)
Message-ID: <20070606125259.GA5491@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com> <1181013756.31677.123.camel@localhost.localdomain> <1181023787.2785.14.camel@entropy> <1181028453.31677.127.camel@localhost.localdomain> <1181087462.2788.8.camel@entropy> <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com> <1181088936.2788.10.camel@entropy> <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com> <1181091523.2788.28.camel@entropy> <1181098204.31677.158.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181098204.31677.158.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 12:50:04PM +1000, Benjamin Herrenschmidt wrote:
> Yeah, synchronous signals should probably never be delivered to another
> process, even via signalfd. There's no point delivering a SEGV to
> somebody else :-)

Sure there is.  UML does exactly that - intercepting child signals
(including SEGV) with wait.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
