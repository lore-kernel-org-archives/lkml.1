Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYHRMzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYHRMzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYHRMzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:55:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYHRMzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:55:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080818100151.c2e9e508.sfr@canb.auug.org.au>
References: <20080818100151.c2e9e508.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-next@vger.kernel.org, David Fries <david@fries.net>,
       James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: origin tree build failure
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 18 Aug 2008 13:55:30 +0100
Message-ID: <17141.1219064130@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> As expected (reported by David Fries), today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from include/linux/tracehook.h:52,
>                  from arch/powerpc/kernel/signal.c:13:
> include/linux/security.h: In function 'security_ptrace_traceme':
> include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)
> 
> Caused by commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40 ("security: Fix
> setting of PF_SUPERPRIV by __capable()").  The version of this commit
> that has been in the linux-next tree from Aug 8 to Aug 15 is correct, so
> I have no idea what happened.

I accidentally posted an old patch which James, maybe, substituted for the
good one that he had.

David
