Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbXKFXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbXKFXCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbXKFXBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:01:10 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60761 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755602AbXKFXBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:01:08 -0500
Date: Wed, 7 Nov 2007 00:00:44 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106230044.GO26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <20071106080637.GB26163@stusta.de> <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711060738270.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 07:39:09AM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 6 Nov 2007, Adrian Bunk wrote:
> > 
> > How do we get the information about the character encoding of the string 
> > to be parsed into the kernel?
> 
> I really would expect that kernel strings don't have an encoding. They're 
> just C strings: a NUL-terminated stream of bytes.

You were the one who suggested to _parse_ strings in the kernel.

Some basic parsing is possible due to the fact that all encodings you 
usually get are extensions of ASCII with additional properties.

But in this thread we discussed that the following implemented things
in Smack and TOMOYO currently do not work correctly when the string
is encoded in UTF-8:
- isgraph()
- isspace()
- match one character

How do you suggest to implement them in a safe way without knowing about 
the encoding?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

