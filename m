Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbYBPAnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbYBPAnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYBPAnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:43:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:50819 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYBPAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=myQ3CuLpQNujwizfNOyT2dX3NpDZLpzhbGfEWIZbr1YSoIX0TtO9fBKIpi/ryo4JyI58nmNStkhWrn2jI0e3xBRjuqPFJjLfCQPcbXo+v3ZducJl3Ww3jaBaabXETYRASiv/GkDCCzF6jqKnFGOkwIGS3du1pi5shXDu08i+iXU=
Date: Sat, 16 Feb 2008 03:42:49 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080216004249.GA3263@martell.zuzino.mipt.ru>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080216000943.GD31474@flint.arm.linux.org.uk> <20080215162121.317c7c1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215162121.317c7c1c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:21:21PM -0800, Andrew Morton wrote:
> On Sat, 16 Feb 2008 00:09:43 +0000
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > For reference, even _I_ don't build test the entire set of ARM defconfigs -
> > at about 7 minutes a build, 75 defconfigs, that's about 9 hours...  I
> > just build those which are important to myself, hope that the others are
> > fine, and rely on kautobuild finding any breakage.
> > 
> 
> you need a better box ;)
> 
> cerfcube_defconfig:				35 seconds
> carmeva_defconfig:				23 seconds
> spitz_defconfig (one of the biggest):		45 seconds
> 
> so would a stupid `for i in arch/arm/configs/*' script be sufficient
> coverage?

I do this wildcard together with 

	yes '' | make ARCH=arm ... oldconfig
	make

Sans toolchain issues, it's pretty good -- Russell larts you when some
defconfig becomes broken anyway. :^)
