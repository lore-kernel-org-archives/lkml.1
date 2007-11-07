Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXKGAoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXKGAoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 19:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXKGAoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 19:44:15 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58272 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754178AbXKGAoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 19:44:14 -0500
Date: Wed, 7 Nov 2007 01:43:50 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071107004350.GS26163@stusta.de>
References: <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org> <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org> <20071107000705.GQ26163@stusta.de> <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 04:27:19PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Nov 2007, Adrian Bunk wrote:
> > 
> > But if you want to match "one character" (like TOMOYO does) or want to 
> > check for printable characters except space (like Smack does) you must 
> > know whether the byte string 0xC3 0xA0 is the character à or a sequence 
> > of two characters with the second one being NBSP.
> 
> No you don't. You just check the binary value, and decide that ' ', '\t' 
> and '\n' are special.
> 
> Don't go get excited.

How should TOMOYO implement it's "match one character" in a pattern
(used to allow or deny access in a name-based MAC)?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

