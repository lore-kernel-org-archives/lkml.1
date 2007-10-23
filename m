Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbXJWQ6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbXJWQ6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXJWQ5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:57:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41247 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbXJWQ5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:57:48 -0400
Date: Tue, 23 Oct 2007 18:57:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071023165746.GA28392@one.firstfloor.org>
References: <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de> <20071023131009.GA32298@elte.hu> <p73sl427wvu.fsf@bingen.suse.de> <20071023142006.GA9961@elte.hu> <20071023144852.GA27956@one.firstfloor.org> <20071023151309.GA14998@elte.hu> <20071023154417.GA24016@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023154417.GA24016@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 05:44:17PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > [...] -pg should in theory work with -mregparms.
> > 
> > last i checked it didnt work - i'll re-check that.
> 
> earlier gcc versions had problems with -mregparm and with -pg. I just 

Which version was that? 

> did a quick test with latest gcc and at a quick glance it seems to work 
> better - i'll propagate that throught he whole latency tracer to see 
> whether it's indeed working throughout. Anyway, this means that there's 
> no urgent need for this patch and we've dropped it from the x86 queue 
> for now. As long as it only affects older gcc's it's probably not worth 
> force-keeping the annotations for that purpose alone.

Great.

-Andi
