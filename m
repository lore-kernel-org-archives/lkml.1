Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXH3WSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXH3WSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762210AbXH3WSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:18:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:32674 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895AbXH3WSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jlpUgwZmyh/Ae2Y9UXK2rch6QdqpdOPp/QxJdiFClOszU6bP3yGYD5kbDFm2pqqp/+r47eouCvyFbnRg8IaORwOTqsQhU0/F+15+0AJRml+SL457RSkx0ThcPpx7oGJSCPkcgNgwyYUPX3nLCJ9rcwe+eTL3B0phhiTXD20euh4=
Message-ID: <40f31dec0708301518u5ef32d13jfe1cce09656bf77d@mail.gmail.com>
Date: Fri, 31 Aug 2007 01:18:31 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 5/5] Net: ath5k, kconfig changes
Cc: "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20070830123609.GA5140@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2713029743177393055@pripojeni.net>
	 <280951420471148977@pripojeni.net>
	 <20070828171330.GD29343@infradead.org>
	 <40f31dec0708291838p5d33eb34p3b4432d9d270841a@mail.gmail.com>
	 <20070830123609.GA5140@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/30, John W. Linville <linville@tuxdriver.com>:
> On Thu, Aug 30, 2007 at 04:38:09AM +0300, Nick Kossifidis wrote:
> > 2007/8/28, Christoph Hellwig <hch@infradead.org>:
>
> > > Also this whole patch seems rather pointless.  It saves only
> > > very little and turns the driver into a complete ifdef maze.
>
> > Also most
> > people will use 5212 code only, 5211 cards are on some old laptops and
> > 5210, well i couldn't even find  a 5210 for actual testing :P
>
> FWIW, I'd bet dollars to donuts that distros will enable them all
> together.
>
> Is saving code space the only reason to turn these off?  How much
> space do you save?
>
> Is there some way you can isolate and/or limit the number of ifdef
> blocks further?  If so, we might consider a version of this patch
> that depends on EMBEDDED or somesuch...?
>
> John

O.K. as a first step i'll limit 5210 code only then, just an option
like "support older 5210 chipsets" which is going to be off by default
instead of 3 options. It's not just saving space, it's also saving
some runtime checks. It's not really a gain in performance though,
most checks are done during initialization and dfs setup, i just
thought it would be usefull to save as much cpu as possible.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
