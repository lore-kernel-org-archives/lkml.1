Return-Path: <linux-kernel-owner+w=401wt.eu-S1764637AbXFAUVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764637AbXFAUVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764542AbXFAUVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:21:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53171 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764536AbXFAUVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:21:03 -0400
Date: Fri, 1 Jun 2007 22:22:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
Message-ID: <20070601202202.GA4232@uranus.ravnborg.org>
References: <20070531002047.702473071@sgi.com> <20070531003012.302019683@sgi.com> <20070531141147.423ad5e3.akpm@linux-foundation.org> <20070531213046.GA27923@uranus.ravnborg.org> <20070601180200.GA7968@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601180200.GA7968@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 02:02:00PM -0400, Dave Jones wrote:
> On Thu, May 31, 2007 at 11:30:46PM +0200, Sam Ravnborg wrote:
>  > > +	sym = sym_lookup("DEVEL_KERNEL", 0);
>  > > +	sym->type = S_BOOLEAN;
>  > > +	sym->flags |= SYMBOL_AUTO;
>  > > +	p = getenv("DEVEL_KERNEL");
>  > > +	if (p && atoi(p))
>  > > +		sym_add_default(sym, "y");
>  > > +	else
>  > > +		sym_add_default(sym, "n");
>  > > +
>  > 
>  > 		sym_set_tristate_value(sym, yes);
>  > 	else
>  > 		sym_set_tristate_value(sym, no);
>  > 
>  > should do the trick (untested).
> 
> Odd. What's the third state ? Undefined?
no, mod, yes
Representing: no, module, yes as the three config choices.

	Sam
