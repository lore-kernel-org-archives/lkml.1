Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZFXUra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZFXUra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZFXUrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:47:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60854 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZFXUrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:47:13 -0400
Date: Wed, 24 Jun 2009 21:47:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624204715.GU8633@ZenIV.linux.org.uk>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk> <20090624203815.GT8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906241340410.3154@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906241340410.3154@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:41:33PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 24 Jun 2009, Al Viro wrote:
> > 
> > Please, pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linux
> > 
> > Missing ifdef in posix_acl.h...
> 
> I assume that should be 'for-linus'.

So it should.  Apologies...

And another one, in audit tree (audit build breakage fix by eparis)

git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ for-linus

Eric Paris (1):
      audit: inode watches depend on CONFIG_AUDIT not CONFIG_AUDIT_SYSCALL

 kernel/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
