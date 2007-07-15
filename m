Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbXGOWCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbXGOWCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXGOWCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:02:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49434 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbXGOWCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:02:23 -0400
Date: Sun, 15 Jul 2007 23:02:16 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] the wrong variable checked after request_irq()
Message-ID: <20070715220216.GF21668@ftp.linux.org.uk>
References: <E1IAAFp-00053g-Ti@ZenIV.linux.org.uk> <1184535638.25235.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184535638.25235.15.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 07:40:38AM +1000, Benjamin Herrenschmidt wrote:
> On Sun, 2007-07-15 at 20:59 +0100, Al Viro wrote:
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> Out of curiosity, how did you pick it up ? You have some automated tool
> to catch that (or sparse changes) or you just did -lots- of code
> inspection ?

While testing sparse changes, actually (comparing pointers to null
pointer constant spelled without a cast to void *)...  That gave several
hundred hits, most of them being immediately obvious (picking the lines
by file and line number and looking through the list had eliminated all
but about a dozen or two).  Several were not...
