Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZC2Xsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZC2Xsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 19:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZC2Xso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 19:48:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52685 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbZC2Xsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 19:48:43 -0400
Date: Mon, 30 Mar 2009 00:48:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fault.c cleanup, what else could it be
Message-ID: <20090329234839.GL28946@ZenIV.linux.org.uk>
References: <20090329175642.GA26405@x200.localdomain> <20090329232422.GA9873@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329232422.GA9873@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 01:24:22AM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > I have personally stopped sending anything against pure arch/x86/ 
> > if there is even a smallest chance it can be prettyfied like this.
> 
> Before you volunteer reviewing x86 code for us (thanks for that!), 
> may i direct your urgent attention at code in your own area of 
> responsibility - such as fs/proc/base.c:
> 
>     total: 85 errors, 39 warnings, 2 checks, 3147 lines checked
> 
> I filtered out the relevant ones for you below.

This is precisely what's wrong with your advocacy.  I actually have no
problem with specific instances pointed to by checkpatch.pl in this case;
when code in question gets touched, sure, getting rid of those would be OK.
*HOWEVER*, implying that this noise should take priority over any real work
is bloody insane.  And replying to mail that questions the usefulness of
such activity with "shut up, do what you've pretty much called pointless
and don't come back until you are done"... fie, sir.
