Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXDZUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXDZUhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbXDZUhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:37:40 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752820AbXDZUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:37:39 -0400
Date: Thu, 26 Apr 2007 13:37:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.21-rc7-mm2
Message-Id: <20070426133720.25085207.akpm@linux-foundation.org>
In-Reply-To: <46309142.2010907@googlemail.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46309142.2010907@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 13:47:14 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
> >
> >
> > - this has everything which is in 2.6.21.  Plus more!
> >
> > - a number of nasty bugs were fixed.  This should be (a lot) more stable
> >   than 2.6.21-rc7-mm1.
> >
> >   
> 
> I get this warning here :
> 
> 
> drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
> 'UCC_GETH' refer to undefined symbol 'UCC_FAST'

Yes, we get so many of those that I tend to ignore them, assuming that
someone will pick it up and fix it.

This one was added by git-powerpc, presumably
7d776cb596994219584257eb5956b87628e5deaf "QE: automatically select QE
options"
