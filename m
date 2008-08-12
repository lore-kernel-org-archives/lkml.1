Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYHLJ2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYHLJ2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYHLJ2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:28:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYHLJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:28:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080812093624.de7d4ad8.sfr@canb.auug.org.au>
References: <20080812093624.de7d4ad8.sfr@canb.auug.org.au> <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org> <20080811101602.09555609.sfr@canb.auug.org.au> <20080811153536.02ac0561.sfr@canb.auug.org.au> <alpine.LRH.1.10.0808120751001.10017@tundra.namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Resolved merge conflicts in next-creds
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Tue, 12 Aug 2008 10:27:08 +0100
Message-ID: <22136.1218533228@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> The important thing (and what is different in what I have proposed) is
> that what you are asking Linus to take here has zero impact (i.e. you just
> add a header file that noone uses and whose contents are clearly noops)
> and then it is very obvious that when people start to use it, the changes
> really cannot introduce a regression.

Actually, you do have to modify XFS too.  It declares current_fsuid(),
current_fsgid() and struct cred within itself.  The first two just require
some simple renames, and the third just requires using my struct cred instead
when it appears.

David
