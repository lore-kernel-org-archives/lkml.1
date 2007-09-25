Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXIYQd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXIYQd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXIYQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:33:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46083 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbXIYQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:33:48 -0400
Date: Tue, 25 Sep 2007 09:33:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Newall <david@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
       Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070925093320.51505c79@laptopd505.fenrus.org>
In-Reply-To: <46F92AAB.1060903@davidnewall.com>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
	<46F29A9A.4070806@davidnewall.com>
	<200709201817.17282@x5>
	<46F2B59F.8090709@davidnewall.com>
	<46F2DDD0.3030500@tmr.com>
	<46F380E4.4040606@davidnewall.com>
	<20070924213215.GA32716@vino.hallyn.com>
	<46F83474.5040503@davidnewall.com>
	<20070924230008.GA3160@vino.hallyn.com>
	<46F8BC8A.7080006@davidnewall.com>
	<20070925114947.GA9721@vino.hallyn.com>
	<46F91417.9050600@davidnewall.com>
	<46F924E3.50205@davidnewall.com>
	<20070925163040.12a3c2f8@the-village.bc.nu>
	<46F92AAB.1060903@davidnewall.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 01:05:07 +0930
David Newall <david@davidnewall.com> wrote:

> Alan Cox wrote:
> >> Marek's loading dynamic libraries, it seems clear that the prime
> >> purpose of chroot is to aid security.  Being able to cd your way
> >> out is handy 
> >
> > Does it - I can't find any evidence for that.
> 
> It seems self-evident to me.  What do you think is it prime purpose?
> 
> 

the prime purpose is that you can have different sets of userspace libs
for testing or parallel deployment (for example this is used in many
distribution build systems)
