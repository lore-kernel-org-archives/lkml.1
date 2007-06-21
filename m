Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbXFUPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbXFUPAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbXFUPAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:00:24 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:38653 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbXFUPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:00:23 -0400
Date: Thu, 21 Jun 2007 11:00:22 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070621150022.GY10008@csclub.uwaterloo.ca>
References: <MDEHLPKNGKAHNMBLJOLKKEIFEKAC.davids@webmaster.com> <orodjfkzjt.fsf@oliva.athome.lsd.ic.unicamp.br> <20070620140101.GU10008@csclub.uwaterloo.ca> <or1wg6uz53.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or1wg6uz53.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 05:52:40PM -0300, Alexandre Oliva wrote:
> On Jun 20, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:
> > A patent prevents you from using the software in any way at all,
> > while a hardware restriction prevents you from using the software on
> > that particular hardware, but not on lots of other hardware.  Very
> > big difference.
> 
> So, one disrespects a lot, the other disrespects a little.  Is that
> relevant, when the requirement is "no further restrictions"?

What about the freedom to buy devices with certified code on it, while
still being able to look through the source code and verify for yourself
that it is correct and not full of bugs?  Would it be better if the
devices that have to be certified and locked down used secret code so
that the purchaser can't verify the code?

Apparently the only restrictions ever permitted are the ones the FSF
thinks of.

> > So what would happen if some company was to make software for a tivo and
> > released their binaries signed with some specific key, and they released
> > information on how to check this was signed with their key, and then
> > some other companies went and made tivo hardware and decided that they
> > would only allow code signed by the first companies key to run on it,
> 
> I was pretty sure this had been covered in the section about technical
> barriers to modification in the third draft's rationale, but I can't
> find it right now.  http://gplv3.fsf.org/gpl3-dd3-rationale.pdf

So really what the GPL v3 wants to have is to make sure that the user
can reproduce from the sources a bit for bit identical copy of the
binaries?  Too bad compilers that put time stamps and such into the
binary would make that imposible.  I don't think there is any way that
can be written into the GPL that can prevent all loop holes for how to
make signed binaries.

> Anyhow, the argument I read went like: if there's an agreement between
> the parties to do this, then the copyright holder can probably enforce
> the license regardless of the software and hardware distributor being
> different parties, since the software is being distributed with
> information whose purpose is to enable the hardware to deny the user
> the freedom to run modified versions of the software.

There doesn't have to be an agreement.  The software company could just
release specs for a hardware design and let others freely go and build
them from that design.

> However, if there's no such agreement, if the copyright holder has no
> copyright claims over the hardware or works shipped in it, there's
> nothing the copyright holder can do about it, and that's probably how
> it should be, since a copyright license (!= contract) can't possibly
> prohibit people from creating hardware limited in function, it can
> only tell people that, in order for them to have permission to modify
> or distribute the covered work, they must abide by certain conditions.
> And if they don't want to abide by the conditions, and they don't
> manage to obtain a license from the copyright holders that doesn't
> impose conditions they can't accept, they just can't modify or
> distribute the work.

But if the hardware ships with only code that simply waits for the user
to provide some code for it to isntall (which has to be signed in a way
the hardware likes), then the hardware has nothing to do with the
license of the software.

The signed binaries from the service provider/software developer on the
other hand is GPL and the sources are released with changes.  They just
happen to sign their binaries in a way that allows them to install on
the hardware in question.  It could also install on hardware that
doesn't check the signature as long as it is functionally identical
otherwise.

I hope no one does this, but I still don't see how the GPLv3 draft deals
with this case, or even how it could deal with it.

--
Len Sorensen
