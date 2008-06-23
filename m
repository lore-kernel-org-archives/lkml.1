Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbYFWS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbYFWS44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbYFWS4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:56:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36982 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760168AbYFWS4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:56:45 -0400
Date: Mon, 23 Jun 2008 20:57:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Message-ID: <20080623185728.GB30550@uranus.ravnborg.org>
References: <1209577322.25560.402.camel@pmac.infradead.org> <87bq3rgq40.fsf@basil.nowhere.org> <1209582709.25560.441.camel@pmac.infradead.org> <200806231922.10864.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806231922.10864.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 07:22:10PM +0200, Denys Vlasenko wrote:
> On Wednesday 30 April 2008 21:11, David Woodhouse wrote:
> > On Wed, 2008-04-30 at 20:22 +0200, Andi Kleen wrote:
> > > David Woodhouse <dwmw2@infradead.org> writes:
> > > 
> > > > Andrew Morton has been saying recently that we need an 'embedded
> > > > maintainer', to take responsibility for 'embedded issues' in the core
> > > > kernel, as well as trying to improve our relationship with those using
> > > > the Linux kernel for 'embedded' devices -- who have a reputation of
> > > > not working with us very closely; to their detriment as well as our
> > > > own.
> > > 
> > > I hope your job description doesn't include adding more and more
> > > CONFIGs though.
> > > 
> > > I am sure there are lots of low hanging fruit where memory can be
> > > saved and it's a good thing someone cares about that, but please don't
> > > focus on the code size only. Or if you work on that don't do it 
> > > using CONFIG or when you really add a new one find some other 
> > > that is pointless and remove it first. 
> > > 
> > > There are simply already far too many of them and they make the 
> > > kernel harder and harder to change.
> > 
> > I agree. And if we do want to pay attention to pure code size, there are
> > other approaches -- like --gc-sections
> 
> I have some patches in this area too. Were submitted to Sam
> but he was too busy it seems.
They were not trivial to apply and so went down on the TODO list.
We could try to push the generic and x86 specific .lds stuff via
the arch maintainers?

	Sam
