Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbZC3BeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbZC3BeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZC3Bd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:33:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36673 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZC3Bd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:33:58 -0400
Date: Mon, 30 Mar 2009 02:33:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090330013355.GO28946@ZenIV.linux.org.uk>
References: <20090329175642.GA26405@x200.localdomain> <20090329232422.GA9873@elte.hu> <20090329234839.GL28946@ZenIV.linux.org.uk> <20090330011355.GA11087@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330011355.GA11087@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:13:55AM +0200, Ingo Molnar wrote:

> There is simply no excuse for ever having let that crap get there 
> into fs/proc/base.c. There is no excuse for ever letting that crap 
> grow. The fact that that crap is there is proof of systemic failure 
> over the years to keep that code clean.

Nothing like proof by assertion, eh?

> I dont really want to see "real work" done on code that was not 
> properly and cleanly finished in the first place.

Tough.  At the moment we have a rather unpleasant hole with tentative fix
that touches fs/proc/base.c.  Whether you want said work postponed until all
whitespace wanking is done on file in question or not, I simply don't give
a damn - getting rid of real bug takes precedence.  Whitespace crap should
be dealt with as we go through the functions containing such crap, religious
bullshit nonwithstanding.

And I very much object against completely unfounded assertions claiming
that checkpatch noise makes a useful proxy for code quality.  You keep
making those again and again, without a shred of evidence to show.
