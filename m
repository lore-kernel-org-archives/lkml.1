Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbXKFXIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbXKFXIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbXKFXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:08:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbXKFXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:08:37 -0500
Date: Tue, 6 Nov 2007 15:08:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
In-Reply-To: <20071106230044.GO26163@stusta.de>
Message-ID: <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
 <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu>
 <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
 <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
 <20071106230044.GO26163@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Nov 2007, Adrian Bunk wrote:
> 
> You were the one who suggested to _parse_ strings in the kernel.

So?

We do that for lots of things.

What do you think a filename is? And yes, we parse it. Things like '/' and 
'.' and '..' have magic meaning.

You don't need to bring up idiotic things like character sets. You can see 
it as a byte string. You're done with it.

		Linus
