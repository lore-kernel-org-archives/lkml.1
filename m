Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbXKGBH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbXKGBH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXKGBHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:07:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59940 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526AbXKGBHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:07:18 -0500
Date: Tue, 6 Nov 2007 17:06:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <20071107004350.GS26163@stusta.de>
Message-ID: <alpine.LFD.0.999.0711061705340.15101@woody.linux-foundation.org>
References: <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz>
 <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
 <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
 <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
 <20071107000705.GQ26163@stusta.de> <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org>
 <20071107004350.GS26163@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Nov 2007, Adrian Bunk wrote:
>
> How should TOMOYO implement it's "match one character" in a pattern
> (used to allow or deny access in a name-based MAC)?

.. I think such a design is fundamentally bogus. You don't have 
"characters". You have "bytes".

So you either implement "match one byte", or you go crazy. It's that 
simple.

		Linus
