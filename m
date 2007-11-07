Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXKGB7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXKGB7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbXKGB7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:59:37 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45693 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754712AbXKGB7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:59:36 -0500
Date: Wed, 7 Nov 2007 02:59:12 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071107015912.GT26163@stusta.de>
References: <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org> <20071106230044.GO26163@stusta.de> <alpine.LFD.0.999.0711061506550.15101@woody.linux-foundation.org> <20071107000705.GQ26163@stusta.de> <alpine.LFD.0.999.0711061626410.15101@woody.linux-foundation.org> <20071107004350.GS26163@stusta.de> <alpine.LFD.0.999.0711061705340.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711061705340.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 05:06:23PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Nov 2007, Adrian Bunk wrote:
> >
> > How should TOMOYO implement it's "match one character" in a pattern
> > (used to allow or deny access in a name-based MAC)?
> 
> .. I think such a design is fundamentally bogus. You don't have 
> "characters". You have "bytes".

Users are used to work on characters, not on bytes.

> So you either implement "match one byte", or you go crazy. It's that 
> simple.

Sure, you can limit what is possible and what not.

But there are still many pitfalls, e.g. if someone would allow the 
construct "[abc]" in patterns for matching one of these characters you'd 
have to ensure that your syntax contains explicit character delimiters 
or a pattern might match something completely different from what was 
intended.

My opinion is that extended parsing of non-ASCII strings will cause too 
many problems, but it seems we can only agree to disagree on this.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

