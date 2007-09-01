Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbXIAF62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbXIAF62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 01:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXIAF6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 01:58:17 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:38719 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbXIAF6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 01:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fx0cLTAshk2Q94GyUO1yadZZ5Mp+VFKPlm2pUdINgmC0bFW9XMd/ra+nmjC7UNu+PjuFpKHFna9sAjFU8xgMtN7jsxF2eOxgacE9X6obztOCNm4RI1ZN2jxscaVZ3h6R/pD+cK0og2IS2pK6hUi+/xRIS5u73IO6R1Uv4/k6kL0=
Message-ID: <40f31dec0708312258h1d77fc4eu54460bf70f119d27@mail.gmail.com>
Date: Sat, 1 Sep 2007 08:58:15 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <40f31dec0708301518u5ef32d13jfe1cce09656bf77d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2713029743177393055@pripojeni.net>
	 <280951420471148977@pripojeni.net>
	 <20070828171330.GD29343@infradead.org>
	 <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
	 <20070830123609.GA5140@tuxdriver.com>
	 <40f31dec0708301518u5ef32d13jfe1cce09656bf77d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/31, Nick Kossifidis <mickflemm@gmail.com>:
> 2007/8/30, John W. Linville <linville@tuxdriver.com>:
> > On Thu, Aug 30, 2007 at 04:38:09AM +0300, Nick Kossifidis wrote:
> > > 2007/8/28, Christoph Hellwig <hch@infradead.org>:
> >
> > > > Also this whole patch seems rather pointless.  It saves only
> > > > very little and turns the driver into a complete ifdef maze.
> >
> > > Also most
> > > people will use 5212 code only, 5211 cards are on some old laptops and
> > > 5210, well i couldn't even find  a 5210 for actual testing :P
> >
> > FWIW, I'd bet dollars to donuts that distros will enable them all
> > together.
> >
> > Is saving code space the only reason to turn these off?  How much
> > space do you save?
> >
> > Is there some way you can isolate and/or limit the number of ifdef
> > blocks further?  If so, we might consider a version of this patch
> > that depends on EMBEDDED or somesuch...?
> >
> > John
>
> O.K. as a first step i'll limit 5210 code only then, just an option
> like "support older 5210 chipsets" which is going to be off by default
> instead of 3 options. It's not just saving space, it's also saving
> some runtime checks. It's not really a gain in performance though,
> most checks are done during initialization and dfs setup, i just
> thought it would be usefull to save as much cpu as possible.
>

Well after some thought i removed them all, there is no real gain from
this in most cases (that ppl will use newer 5212 chips and
combatibles).



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
