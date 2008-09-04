Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYIDX5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYIDX5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYIDX5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:57:34 -0400
Received: from iabervon.org ([66.92.72.58]:37068 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYIDX5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:57:33 -0400
Date: Thu, 4 Sep 2008 19:57:32 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <alpine.LNX.1.00.0809031317080.19665@iabervon.org>
Message-ID: <alpine.LNX.1.00.0809041956220.19665@iabervon.org>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.00.0809031317080.19665@iabervon.org>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Daniel Barkalow wrote:

> On Wed, 3 Sep 2008, Dmitry Torokhov wrote:
> 
> > On Wed, Sep 03, 2008 at 01:50:35PM +0200, Jiri Kosina wrote:
> > > On Tue, 2 Sep 2008, Dmitry Torokhov wrote:
> > > 
> > > > I guess we could use System's product name to differentiate between 
> > > > Cristopher's and Daniel's boards. Although I must admit it is the very 
> > > > first time when I see a box that behaves better with active mux. DOes 
> > > > Vista use active mux nowadays? Because if it is not then I bet there is 
> > > > (or shortly will be) a BIOS update fixing legacy mode on Daniel's box.
> > > 
> > > I guess so, yes.
> > > 
> > > On the other hand, this might also be viewed as regression (we made 
> > > Daniel's hardware behave worse with recent kernel than it did before), so 
> > > I think we still would like to have this fixed. What about the patch 
> > > below, adding the match on System's product name, as you suggested? 
> > > Thanks.
> > > 
> > 
> > I agree. Daniel, could you please try the patch to make sure it
> > restores the previous behavior for you and I will push it through.
> > 
> > Thanks!
> 
> I'll test that Thursday as well; is there some quick way to determine 
> whether you're using active mux or not?

That patch, on top of 2.6.25.10 does give me 4 AUX ports, so I think it is 
getting the previous behavior as expected.

	-Daniel
*This .sig left intentionally blank*
