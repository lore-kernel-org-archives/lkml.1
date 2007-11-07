Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXKGA2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXKGA2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXKGA1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:27:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbXKGA1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:27:52 -0500
Date: Tue, 6 Nov 2007 16:27:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <20071107000705.GQ26163@stusta.de>
Message-ID: <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
 <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu>
 <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
 <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
 <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
 <20071107000705.GQ26163@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Nov 2007, Adrian Bunk wrote:
> 
> But if you want to match "one character" (like TOMOYO does) or want to 
> check for printable characters except space (like Smack does) you must 
> know whether the byte string 0xC3 0xA0 is the character à or a sequence 
> of two characters with the second one being NBSP.

No you don't. You just check the binary value, and decide that ' ', '\t' 
and '\n' are special.

Don't go get excited.

		Linus
