Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbYGAUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbYGAUId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYGAUIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:08:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48861 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYGAUIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:08:23 -0400
Date: Tue, 1 Jul 2008 22:09:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Avi Kivity <avi@qumranet.com>, linux-arch@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove dummy asm/kvm.h files
Message-ID: <20080701200910.GA10677@uranus.ravnborg.org>
References: <20080701162716.GB32598@cs181140183.pp.htv.fi> <20080701193236.GB10350@uranus.ravnborg.org> <1214942000.10393.418.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214942000.10393.418.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:53:20PM +0100, David Woodhouse wrote:
> On Tue, 2008-07-01 at 21:32 +0200, Sam Ravnborg wrote:
> > On Tue, Jul 01, 2008 at 07:27:16PM +0300, Adrian Bunk wrote:
> > > This patch removes the dummy asm/kvm.h files on architectures not (yet) 
> > > supporting KVM and uses the same conditional headers installation as
> > > already used for a.out.h .
> > > 
> > > Also removed are superfluous install rules in the s390 and x86 Kbuild 
> > > files (they are already in Kbuild.asm).
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > I really do not like the way we implement these checks and
> > think this should be a kconfig option.
> > But we do not (yet) require a configured kernel when exporting
> > to userspace so this is not feasible right now.
> 
> I'm _really_ dubious about doing this kind of thing through Kconfig.
> 
> In the general case, we really don't want exported headers to have any
> differences based on the kernel configuration.
> 
> Yes, I suppose it would be OK if we are very careful not to let anyone
> use config symbols that aren't hard-coded for the given architecture.
> But in practice I don't think there's any real chance that we'd manage
> to be careful _enough_. We'd find people using symbols they shouldn't
> be.
We have two cases now and I think we can manage it.
But if we have only a few cases then we can also accept use of ARCH.

> 
> > So despite the above this patch has my:
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > Same for the asm/a.out patch you posted the other day.
> > 
> > David - I assume you take these via your tree?
> 
> I can do.
Thanks,

	Sam
