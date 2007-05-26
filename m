Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbXEZNep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbXEZNep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbXEZNee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:34:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36848 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753841AbXEZNed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:34:33 -0400
Date: Sat, 26 May 2007 14:34:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Crispin Cowan <crispin@novell.com>
Cc: casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
Message-ID: <20070526143419.550bea93@the-village.bc.nu>
In-Reply-To: <4657C547.6030506@novell.com>
References: <312681.33492.qm@web36609.mail.mud.yahoo.com>
	<4657C547.6030506@novell.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As such, AA can detect whether you did exec("gzip") or exec("gunzip")
> and apply the policy relevant to the program. It could apply different

That's not actually useful for programs which link the same binary to
multiple names because if you don't consider argv[0] as well I can run
/usr/bin/gzip passing argv[0] of "gunzip" and get one set of policies and
the other set of behaviour.

And then we have user added hardlinks of course.

