Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbYD2TTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbYD2TTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYD2TTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:19:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43466 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYD2TTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:19:13 -0400
Date: Tue, 29 Apr 2008 21:19:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, ajackson@redhat.com,
       airlied@redhat.com, benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] make access_process_vm work on device memory
Message-ID: <20080429191946.GB32685@uranus.ravnborg.org>
References: <20080429113237.614f89a1@cuia.boston.redhat.com> <20080429110919.dc7b8565.akpm@linux-foundation.org> <20080429190132.GA25793@uranus.ravnborg.org> <20080429121322.6da6b176.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429121322.6da6b176.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:13:22PM -0700, Andrew Morton wrote:
> On Tue, 29 Apr 2008 21:01:32 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > urgh.
> > > 
> > > We have HAVE_ARCH*
> > > We have __HAVE_ARCH*
> > > We have ARCH_HAS*
> > > We have __ARCH_HAS*
> > > 
> > > what a mess.
> > > 
> > > Probably the preferred (but still ugly) approach is to implement
> > > CONFIG_ARCH_*.
> > Only if it is a Kconfig symbol.
> > 
> > We have recently started to use 'HAVE_*' for boolean symbols used
> > to select a specific function for one architecture.
> > See arch/Kconfig for a few samples.
> > 
> > And Documentation/kbuild/kconfig-language.txt for usage hints.
> > 
> 
> I think what you're telling us is to use CONFIG_HAVE_IOREMAP_PROT?

I think so. But I just stumbled upon this mail and have not even tried
to follow what you discuss.

So yes - if it is a kconfig symbol.
And if it is a bool.
And if it has no dependencies, or we can create a helper
with no dependencies - so yes.

	Sam
