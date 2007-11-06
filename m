Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXKFLHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXKFLHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbXKFLHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:07:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54985 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754215AbXKFLHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:07:40 -0500
Date: Tue, 6 Nov 2007 11:02:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106110254.3a461e1c@the-village.bc.nu>
In-Reply-To: <20071106085651.GC26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com>
	<20071103164303.GA26707@ubuntu>
	<20071106063305.GA26163@stusta.de>
	<C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com>
	<20071106085651.GC26163@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The documentations says:
> "Smack labels cannot contain unprintable characters or the "/" (slash) 
>  character."
> 
> What you propose might contain unprintable characters, and it might even 
> be invalid UTF-8.

Just like filenames then. I haven't noticed the vfs explode as a result

Alan
