Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXGaQx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXGaQx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763391AbXGaQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:53:19 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48415 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763177AbXGaQxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:53:18 -0400
Date: Tue, 31 Jul 2007 18:54:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make headers_check less chatty for success cases
Message-ID: <20070731165433.GA8180@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0707312206140.28746@enigma.security.iitk.ac.in> <1185899409.3083.122.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185899409.3083.122.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 05:30:09PM +0100, David Woodhouse wrote:
> On Tue, 2007-07-31 at 22:10 +0530, Satyam Sharma wrote:
> > "make headers_check" is too verbose. It likes to chat even if it has
> > just _successfully_ checked a header, and not just on seeing errors.
> > What is worse, even if you touch just one little header in some corner
> > (or possibly none) and type "make" on an "already-made" tree,
> > headers_check still feels obliged to check all the headers.
> 
> Didn't Sam have a better fix for that?
In another .git here but not yet quite ready.
Got sidetracked by even more section mismatch stuff. If I had knew
how much work that had generated I had not integrated these harmless
scripts in modpost I think ;-)

I will give it a spin soon and post an update.

	Sam
