Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbXK2RlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbXK2RlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759693AbXK2RlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:41:11 -0500
Received: from [81.2.110.250] ([81.2.110.250]:38998 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758938AbXK2RlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:41:10 -0500
Date: Thu, 29 Nov 2007 17:36:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tvrtko.ursulin@sophos.com
Cc: Al Viro <viro@ftp.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
Message-ID: <20071129173601.34273083@the-village.bc.nu>
In-Reply-To: <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	<OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> closed. But more importantly further access to it can be blocked until 
> appropriate actions are taken which also applies with your example, no? Is 

That bit is hard- very hard.

> it possible to open for execute and have dirty mappings (or open for 
> write) on a file at the same time?

If I want I can have 16 threads executing code in a shared object being
written to by ten other programs at once and shared over a network while
we are at it. Its probably not a good idea but I can do it if I have
reason to.

Unix and Linux likewise take the basic view that locking is a problem for
the user, while file permissions prevent it being made a problem for
other users.
