Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbXFVE7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbXFVE7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXFVE7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:59:44 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:35562 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbXFVE7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:59:43 -0400
Date: Fri, 22 Jun 2007 00:59:40 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Message-ID: <20070622045940.GJ602@delft.aura.cs.cmu.edu>
Mail-Followup-To: Alexandre Oliva <aoliva@redhat.com>, davids@webmaster.com,
	linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKEEINEMAC.davids@webmaster.com> <orvedgj3hu.fsf@oliva.athome.lsd.ic.unicamp.br> <20070622005834.GD602@delft.aura.cs.cmu.edu> <or645ghbh8.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or645ghbh8.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 01:14:27AM -0300, Alexandre Oliva wrote:
> On Jun 21, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> > On Thu, Jun 21, 2007 at 08:23:57PM -0300, Alexandre Oliva wrote:
> >> It's not like anyone can safely tivoize devices with GPLv2 already, 
> 
> > So you really didn't pay any attention to anything people told you?
> 
> Yes.  Particularly to what Alan Cox and his legal counsel told me.  A
> single copyright holder able and willing to enforce the license
> against tivoization is enough.  What part of this don't you
> understand?
> 
> > The license does not grant the right that you will be able to run the
> > software on any particular platform or whether it will even work at all.
> 
> It doesn't grant TiVo the right to distribute the program without
> corresponding source code.
> 
> They fail to distribute the source code to the functional signature
> derived from the kernel binary.
> 
> Kaboom!

A signature is not a creative work and as such not covered by copyright.

At the moment the only protection that the signature/key has is that of
a trade secret, the GPLv2 does not cover that type of intellectual
propery and does not grant the licensee access to trade secrets.

Show me any case law that indicates otherwise. Maybe the content
producers will at some point manage to establish that encryption keys
and signatures are somehow copyrightable, but until a court of law
makes that determination there is no kaboom here.

> As for the right to run the program, I've also explained why in
> Brazilian copyright law this is a right granted by the license,
> because the license says that right is unrestricted.
>
> Kaboom!

No, the license says that it does not address the right to run a
program, and states that the license does not impose restrictions.
That is quite different from saying that the right is unrestricted.

So again, not much of a kaboom here either.

> > A mutual compatibility agreement (sublicense) would effectively
> > terminate any rights granted by the GPLv2,
> 
> Additional permissions to combine are not permission to relicense.
> Look at section 13 of GPLv3dd4 and of Affero GPLv3dd1.  That's the
> sort of additional permission I'm talking about here.

I'm talking about the GPLv2, so it doesn't matter what the GPLv3 says
wrt. additional permissions. Even if GPLv2 and GPLv3 grant the same
freedoms (permissions), the collective work would have additional
restrictions because of the GPLv3 code and as such the combined work
would result in a sublicensing of the GPLv2 licensed code, which is
explicitly not permitted.

> The same kind of additional permission that GPLed projects that use
> openssl adopt.

If they are the original author they can make that decision, just like
authors can dual-license, or decide to license their code as GPLv2+. It
is kind of funny how they phrase the exception as granting permission to
link against OpenSSL, where in reality they accept the added restriction
that results from the advertising clause of the BSD license. (i.e.
instead of granting you an additional freedom, they chose to remove the
freedom to modify the part of the code that advertises).

However with the openssl case there is no tight coupling because openssl
is a separate library. Some people have argued that the LGPL was never
really necessary because (unlike static libraries) shared libraries are
still separable from the GPL'd program.

Furthermore, those projects are not pulling individual source files from
into their project. There are also alternative crypto libraries (gnutls,
nessie) which can in many cases easily replace the openssl dependency.

Finally the original author accepts the additional restriction that
comes from the BSD + advertising clause, while the GPLv2 authors do not
accept the additional restrictions they would inherit from the GPLv3
otherwise they would re-license their code to GPLv2+.

Jan

