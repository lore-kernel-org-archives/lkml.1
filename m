Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXHaE5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXHaE5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbXHaE5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:57:46 -0400
Received: from pat.uio.no ([129.240.10.15]:59733 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXHaE5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:57:45 -0400
Subject: RE: recent nfs change causes autofs regression
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708302134500.25853@woody.linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	 <1188513433.6626.24.camel@heimdal.trondhjem.org>
	 <001001c7eb57$afd2d320$0f787960$@com>
	 <1188516173.6626.46.camel@heimdal.trondhjem.org>
	 <001501c7eb5d$d295d870$77c18950$@com>
	 <1188517070.6626.54.camel@heimdal.trondhjem.org>
	 <001601c7eb5f$b6146980$223d3c80$@com>
	 <1188534682.6626.70.camel@heimdal.trondhjem.org>
	 <alpine.LFD.0.999.0708302134500.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 00:57:40 -0400
Message-Id: <1188536260.6626.95.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.058)
X-UiO-Scanned: 968AD9183DBB94F7AB7A33ED899C95E84530971A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 167 total 3574595 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 21:38 -0700, Linus Torvalds wrote:
> 
> On Fri, 31 Aug 2007, Trond Myklebust wrote:
> > 
> > No. Solaris defaults to breaking cache consistency.
> 
> If so, and since that's obviously what people _expect_ to happen, why not 
> make that the default, with the "consistent" behaviour being the one that 
> needs an explicit option.

The majority of "nfs sucks" complaints result from the general lack of
understanding by sysadmins of the nfs caching model. I'd be very
sceptical of any claim that most sysadmins "expect" broken cache
consistency as a result of mounting the same filesystem with different
mount options.

> Just out of curiosity - Hua, is this NFSv2? Especially there, cache 
> "consistency" is largely a joke anyway, so defaulting to some annoying 
> careful mode is doubly ridiculous.

NFSv2 has a close-to-open caching model which works fine as long as you
don't break the underlying assumptions. See my comment above.

Trond

