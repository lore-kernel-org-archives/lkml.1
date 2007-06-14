Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXFNGZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXFNGZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbXFNGZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:25:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFNGZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:25:17 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<466BCBBC.90305@netone.net.tr>
	<Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	<f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
	<20070610160531.GA12179@kroah.com>
	<f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	<20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
	<or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070613211432.GH10008@csclub.uwaterloo.ca>
	<orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131549000.14121@woody.linux-foundation.org>
	<or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131930120.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 03:24:46 -0300
In-Reply-To: <alpine.LFD.0.98.0706131930120.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 13 Jun 2007 19\:55\:33 -0700 \(PDT\)")
Message-ID: <ory7ingij5.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 13 Jun 2007, Alexandre Oliva wrote:
>> 
>> So, TiVo includes a copy of Linux in its DVR.  

> Stop right there.

> You seem to make the mistake to think that software is something physical.

Err, no.  Software, per legal definitions in Brazil, US and elsewhere,
require some physical support.  That's the hard disk in the TiVO DVR,
in this case.  I don't see how this matters, though.

>> TiVo retains the right to modify that copy of Linux as it sees fit.

>  (b) They never modified "a copy" of Linux - they simply replaced it with
>      "another copy" of Linux. The only thing that actually got *modified* 
>      was their hardware!

Per this reasoning, nobody never modifies software.  When you open a
source file in your editor, you make changes to it, then save it,
you're not modifying it, you're replacing it with another copy, and
the only thing that actually got modified was the hardware.

Maybe look what "modify" means in legal context?

Then refer to the GPL:

  2. You may modify your copy or copies of the Program or any portion
  of it, thus forming a work based on the Program,

> And their hardware (and firmware) will run some integrity checks on 
> *whatever* copies of software they have.  This is all totally outside 
> Linux itself.

Agreed.  But as it turns out they use these checks to stop people from
modifying the copy of Linux they ship in the device, and this
restriction is a GPL violation because they don't provide information
you need to build a functioning modified version.

> Btw, according to your _insane_ notion of "a copy" of software, you can 
> never distribute GPL'd software on a CD-ROM, since you've taken away the 
> right of people to modify that CD-ROM by burning and fixating it.

You don't retain that right yourself.  When you pass that copy on, you
pass it on with all the rights that you have.  No problem here.  This
is no different from the software on ROM.

> And I'm saying that the GPLv2 can mroe straightforwardly be read the way I 
> read it - to talk about software, and to realize that software is not "a 
> copy", it's a more abstract thing.

If you choose to disregard the legal meaning of the legal terms used
in the GPLv2, you may have a point.

> that means that they have to give you access to and control over the
> SOFTWARE.

Yes.  That's all I'm saying.  You just can't use the hardware to take
that control away.  That would be a violation of the license.

> Face it: the GPLv3 is a _new_ license. Making funamentally _different_ and 
> _new_ restrictions that do not exist in the GPLv2,

This is true.

> and do not exist in the preamble.

This is not true.

The spirit remains the same: let people modify and share the software.

If the binary you got can't be created out of the corresponding
sources, something is missing.  If it won't run without this missing
bit, you're missing functional portions of the source code.  This all
means the hardware is being used to impose a restriction on
modification of the software, which is against the spirit of the GPL,
and quite likely against its letter as well.

If you don't want it to be so, you can always add an additional
permission that clarifies this bit, such that TiVO and you will be
happy.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
