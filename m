Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbXJWLi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbXJWLi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbXJWLiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:38:19 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:57843 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXJWLiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:38:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=MnRSuhztShuerfD8EXoFXGNDK9yXc/vz4nBzVvf1V41JY25xj1JwKKWJ32BhvgQ3pjrjMrOoNLba+KYUrg3fkm8Pkjo5hUP4IM3x0M71TDx84Xwwlv4n3/Rd+YVSe41j;
Message-ID: <11103.simon.1193139489@5ec7c279.invalid>
In-Reply-To: <20071022171326.GA30317@kroah.com>
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
    <20071022171326.GA30317@kroah.com>
Date: Tue, 23 Oct 2007 12:38:09 +0100
Subject: Re: LSM conversion to static interface
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Greg KH" <greg@kroah.com>
Cc: "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "Crispin Cowan" <crispin@crispincowan.com>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, October 22, 2007 18:13, Greg KH wrote:
> I agree, that is why customers do not load other random security modules
> in their kernel today, and why they will not do so tomorrow.  So,
> because of that, this whole point about compliance with regulatory law
> seems kind of moot :)
>
> Again, LSM isn't going away at all, this is just one config option for
> allowing LSM to work as a module that is changing.  If a customer
> demands that this feature come back, I'm sure that the big distros will
> be the first to push for it.  But currently, given that there are no
> known external LSMs being used by customers demanding support, I don't
> see what the big issue here really is.

I have an out of tree module to do per-port (tcp/udp) bind permissions,
it works fine with the "capability" module as secondary and I can load
or unload both of them at any time... this recent change completely
breaks that. (I had to #include dummy.c though).

Why should I now need to:
1. reboot every time I change the code when I could just reload modules before?
2. put it into my kernel source tree to use it?

-- 
Simon Arlott
