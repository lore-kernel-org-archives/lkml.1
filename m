Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYBXEuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYBXEuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYBXEub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:50:31 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755295AbYBXEua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:50:30 -0500
Date: Sat, 23 Feb 2008 20:47:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Newall <davidn@davidnewall.com>
cc: Pavel Machek <pavel@ucw.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
       Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
In-Reply-To: <47C0E3D7.50901@davidnewall.com>
Message-ID: <alpine.LFD.1.00.0802232040210.21332@woody.linux-foundation.org>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
 <m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org> <m3k5kxq2ih.fsf@maximus.localdomain> <20080222184518.GB6060@ucw.cz> <m3zlts393a.fsf@maximus.localdomain> <20080223094334.GA3081@elf.ucw.cz> <47C013E2.6040201@davidnewall.com>
 <alpine.LFD.1.00.0802230913380.21332@woody.linux-foundation.org> <47C0E3D7.50901@davidnewall.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 24 Feb 2008, David Newall wrote:
> 
> > which talks more about what matters - too deep indentation.
>
> What's too deep?  Is the following too deep?

It would be, if it weren't artificially so, for violates several kernel 
coding standards, one being that the "case" labels indent with the switch, 
not under it (the other being the placement of braces).

> (Yes, I know, "we don't indent 'case' because it consumes too much
> room."

No, that's not it at all. We don't indent 'case' because it matches with 
the 'switch', not because of any room issues.

> That's inconsistent with the rest of normal indenting style, and
> a poor excuse to keep within an obsolete and unnecessary restriction.)

It's not at all inconsistent. It's just making clear how the parts of the 
function group together.

Indenting a case-statement an extra level is as stupid as indenting "else" 
one extra level from the "if ()" it goes together with. Do you think that 
would be sane?

The fact that the 'case' thing is technically parsed as a separate 
statement in C doesn't change anything.

		Linus
