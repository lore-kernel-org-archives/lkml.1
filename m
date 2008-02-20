Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbYBTOaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbYBTOaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbYBTO3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:29:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34083 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYBTO3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:29:52 -0500
Date: Wed, 20 Feb 2008 14:29:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       hch@infradead.org, serue@us.ibm.com, haveblue@us.ibm.com,
       linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: git tree with VFS stuff
Message-ID: <20080220142937.GX27894@ZenIV.linux.org.uk>
References: <E1JRSaC-0005T2-Ew@pomaz-ex.szeredi.hu> <20080221011348.ef5da6c5.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221011348.ef5da6c5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 01:13:48AM +1100, Stephen Rothwell wrote:
> Hi Miklos,
> 
> On Tue, 19 Feb 2008 14:32:28 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > I've created a git tree with the following mounts related stuff:
> > 
> >   - read-only bind mounts
> >   - /proc/<pid>/mountinfo
> >   - unprivileged mounts
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfsstuff.git master
> > 
> > I guess, giving these a spin in linux-next wouldn't hurt?
> 
> I don't think this is what we want to use linux-next for.  Linux-next is
> really a place for stuff that will pretty clearly go into the next kernel
> release i.e. 2.6.26 right now.  If you want to experiment on things for
> beyond that timeframe, then a snapshot of linux-next may be a good base.
> I will take them when they reach the appropriate subsystem tree and are
> ready for integration.

FWIW, I must apologize for delay with getting the damn tree open on
kernel.org ;-/   The last couple of weeks had been Not Fun(tm) in a
lot of respects.

Hopefully I'll finish putting the damn thing into publishable shape by
tomorrow.  As for the stuff mentioned above...  ro-bind series - definitely
yes, mountinfo - IMO needs a sane discussion of what and how should be shown
wrt propagation state, unprivileged mounts - in the "need to finish reviewing"
pile.
