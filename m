Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbZCNSF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbZCNSF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 14:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZCNSFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 14:05:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZCNSFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 14:05:47 -0400
Subject: Re: [PATCH -tip] x86: cpu/intel.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090314170445.GF31930@elte.hu>
References: <1237034492.4546.1.camel@ht.satnam>
	 <20090314131142.GA29582@uranus.ravnborg.org>
	 <20090314132004.GD17727@elte.hu> <1237037822.4546.8.camel@ht.satnam>
	 <19f34abd0903140700r6c23da9aq6747fbcce7bcc4b2@mail.gmail.com>
	 <20090314153138.GA19459@elte.hu> <1237046650.4546.30.camel@ht.satnam>
	 <20090314170445.GF31930@elte.hu>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 23:35:03 +0530
Message-Id: <1237053903.3144.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 18:04 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Sat, 2009-03-14 at 16:31 +0100, Ingo Molnar wrote:
> > > > 
> > > > I don't really like this change (last hunk). Doesn't it seem a 
> > > > bit pointless? It breaks the symmetry with the masked CPUID 
> > > > levels at the beginning of the function. If somebody wants to 
> > > > add something else to this function, it might have to be 
> > > > reindented again. Or is there a problem with too long lines 
> > > > here?
> > > 
> > > yes, it would be cleaner to put the whole family 15 branch into 
> > > a helper inline function instead.
> > > 
> > 
> > OK, better I keep it unchanged :-)
> 
> Why not implement the cleanup i suggested?

I followed your approached and made new helper function. But the result
was same, in that helper function I have to check for family 15 and rest
of things. So I found nothing was gained, So I again reverted it and
provided you this patch.

Thanks,
--
JSR

