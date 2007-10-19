Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbXJSKM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbXJSKM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXJSKMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:12:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11742 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXJSKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=C5zpyDiDhiZIjjDZsDgEWTC+Xtmn+ANEKuSVoJLhmnf1wp7ZYQe49t7sG48Xn96vA4lxfYC3VT56w+Ni1lbXrxOupvznzxJis6Do+qbbEii7TrMokHj/S2qQiErfs6CF1zWGqFpqOiigQWACqmWGORjlOzZetL53hXtUdbXGmzk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jan Dittmer <jdi@l4x.org>
Subject: Re: libata crash
Date: Fri, 19 Oct 2007 11:12:39 +0100
User-Agent: KMail/1.9.1
Cc: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
References: <20071018164745.GD10674@kernel.dk> <4717C776.5020809@garzik.org> <47185722.8020606@l4x.org>
In-Reply-To: <47185722.8020606@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191112.39515.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 08:05, Jan Dittmer wrote:
> Jeff Garzik wrote:
> > Building on x86-64, I'm betting?  :)
> > 
> > I fell victim to the same thing a few days ago, missing some compile 
> > breakage that only appeared with
> > 
> >     make ARCH=i386 allmodconfig && make ARCH=i386 -sj9
> > 
> > Though am I alone in dreaming of a kernel.org service that would permit 
> > all-arch build testing of a git URL?
> 
> I could add that to the service at http://l4x.org/k/ if there is
> sufficient (>1) interest.

Wow.

When you click on Ok/Fail, you get a build log. One part of it
(make oldconfig output) is not usable much, verbatim .config would be more useful.

But this is a minor nitpicking. Overall looks awesome.
--
vda
