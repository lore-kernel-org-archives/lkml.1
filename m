Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYKMW3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYKMW3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:29:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYKMW2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:28:49 -0500
Received: from ozlabs.org ([203.10.76.45]:36160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYKMW2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:28:48 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18716.43543.256621.825529@cargo.ozlabs.ibm.com>
Date: Fri, 14 Nov 2008 09:28:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>, subrata@linux.vnet.ibm.com,
       linux-arch@vger.kernel.org, drepper@redhat.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       linux-api@vger.kernel.org, linux-man@vger.kernel.org,
       davidel@xmailserver.org, netdev@vger.kernel.org, roland@redhat.com,
       oleg@tv-sign.ru, hch@lst.de, davem@davemloft.net, alan@redhat.com,
       jakub@redhat.com
Subject: Re: [PATCH] reintroduce accept4
In-Reply-To: <18716.43376.534965.688695@cargo.ozlabs.ibm.com>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	<517f3f820811131351l1305b2d2u43ab4e0601d97f93@mail.gmail.com>
	<20081113140541.23754cad.akpm@linux-foundation.org>
	<18716.43376.534965.688695@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> Andrew Morton writes:
> 
> > > I think Ulrich wanted to try to see this patch in for 2.6.28; it's
> > > past the merge window of course, so it's up to you, but I have no
> > > problem with that.
> > 
> > That's easy - I'll send it to Linus and let him decide ;)
> 
> Ulrich's patch only updated x86.  If you're going to send it to Linus,
> please give us other architecture maintainers a chance to get patches
> to you to wire it up on our architectures, and then send Linus the
> combined patch.

Actually, any architecture that uses sys_socketcall should be OK
already, by the looks, and that includes powerpc.

Paul.
