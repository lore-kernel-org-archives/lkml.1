Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZCGXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZCGXkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZCGXki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:40:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:58062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZCGXkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:40:37 -0500
Date: Sat, 7 Mar 2009 15:41:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Initialized radeon -> Oops: 0000 [#1] SMP
Message-ID: <20090307154116.470b2883@infradead.org>
In-Reply-To: <49B3027D.60400@wpkg.org>
References: <49B1754C.50109@wpkg.org>
	<20090307152220.693ab8e8@infradead.org>
	<49B3027D.60400@wpkg.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Mar 2009 00:25:49 +0100
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> Arjan van de Ven schrieb:
> > On Fri, 06 Mar 2009 20:11:08 +0100
> > Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> > 
> >> Don't really know where one should send Oops... Is there a better
> >> place than linux-kernel?
> >>
> >>
> >> First time I see such an oops on this multiseat system. Everything
> >> still works fine though.
> >>
> > 
> > Hi,
> > 
> > if you run the oops through "markup_oops.pl" (and assuming you have
> > CONFIG_DEBUG_INFO set) the oops gets part transformed into a
> > sourcecode dump of where the oops is happening..... that sometimes
> > helps in nailing it down.
> 
> Hmmm, no luck here, or...?
> 
> # zgrep CONFIG_DEBUG_INFO /proc/config.gz
> # CONFIG_DEBUG_INFO is not set

yeah you might want to flip that for next time ;-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
