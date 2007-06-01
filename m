Return-Path: <linux-kernel-owner+w=401wt.eu-S1764740AbXFAUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764740AbXFAUaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764037AbXFAUaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:30:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763490AbXFAUai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:30:38 -0400
Date: Fri, 1 Jun 2007 16:30:06 -0400
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
Message-ID: <20070601203006.GB865@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Roman Zippel <zippel@linux-m68k.org>
References: <20070531002047.702473071@sgi.com> <20070531003012.302019683@sgi.com> <20070531141147.423ad5e3.akpm@linux-foundation.org> <20070531213046.GA27923@uranus.ravnborg.org> <20070601180200.GA7968@redhat.com> <20070601202202.GA4232@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601202202.GA4232@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 10:22:02PM +0200, Sam Ravnborg wrote:
 > On Fri, Jun 01, 2007 at 02:02:00PM -0400, Dave Jones wrote:
 > > On Thu, May 31, 2007 at 11:30:46PM +0200, Sam Ravnborg wrote:
 > >  > > +	sym = sym_lookup("DEVEL_KERNEL", 0);
 > >  > > +	sym->type = S_BOOLEAN;
 > >  > > +	sym->flags |= SYMBOL_AUTO;
 > >  > > +	p = getenv("DEVEL_KERNEL");
 > >  > > +	if (p && atoi(p))
 > >  > > +		sym_add_default(sym, "y");
 > >  > > +	else
 > >  > > +		sym_add_default(sym, "n");
 > >  > > +
 > >  > 
 > >  > 		sym_set_tristate_value(sym, yes);
 > >  > 	else
 > >  > 		sym_set_tristate_value(sym, no);
 > >  > 
 > >  > should do the trick (untested).
 > > 
 > > Odd. What's the third state ? Undefined?
 > no, mod, yes
 > Representing: no, module, yes as the three config choices.

Now I'm even more puzzled.  Why would 'DEVEL_KERNEL' need
to be modular ?

		Dave

-- 
http://www.codemonkey.org.uk
