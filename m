Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbXKGPMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbXKGPMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXKGPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:12:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40044 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbXKGPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:12:40 -0500
Date: Wed, 7 Nov 2007 15:08:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071107150811.517e4c9a@the-village.bc.nu>
In-Reply-To: <20071107015912.GT26163@stusta.de>
References: <20071105094007.GA19367@ubuntu>
	<alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
	<20071106080637.GB26163@stusta.de>
	<alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
	<20071106230044.GO26163@stusta.de>
	<alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
	<20071107000705.GQ26163@stusta.de>
	<alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org>
	<20071107004350.GS26163@stusta.de>
	<alpine.LFD.0.999.0711061705340.15101@woody.linux-foundation.org>
	<20071107015912.GT26163@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Users are used to work on characters, not on bytes.

Absolutely true - but completely missing the point.

When I open a UTF-8 file name as displayed by nautilus the kernel does
byte comparisons. The kernel doesn't care what character set is in use.

> > So you either implement "match one byte", or you go crazy. It's that 
> > simple.
> 
> Sure, you can limit what is possible and what not.

If your regexps are reasonably complete you just have to turn the unicode
match into a byte match. That is a user interface problem - in user space.

Alan
