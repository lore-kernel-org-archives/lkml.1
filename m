Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYBEDmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYBEDmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 22:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYBEDmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 22:42:08 -0500
Received: from ozlabs.org ([203.10.76.45]:35820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYBEDmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 22:42:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Date: Tue, 5 Feb 2008 14:41:53 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200802042311.18762.rusty@rustcorp.com.au> <200802042319.44929.rusty@rustcorp.com.au> <20080204145736.GX27894@ZenIV.linux.org.uk>
In-Reply-To: <20080204145736.GX27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051441.53844.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 01:57:37 Al Viro wrote:
> On Mon, Feb 04, 2008 at 11:19:44PM +1100, Rusty Russell wrote:
> > This patch lets timer callback functions have their natural type
> > (ie. exactly match the data pointer type); it allows the old "unsigned
> > long data" type as well.
> >
> > Downside: if you use the old "unsigned long" callback type, you won't
> > get a warning if your data is not an unsigned long, due to the cast.
>
> No.  There's much saner way to do that and it does not involve any gccisms
> at all.  I'd posted such patches quite a while ago; normal C constructs
> are quite sufficient, TYVM.

If you're referring to your 1 Dec 2006 posting, it was enlightening, but I was 
unable to find any patches.

I'd be interested in seeing what you ended up with; I agree it'd be nice to 
kill that unsigned long.

Thanks,
Rusty.
