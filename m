Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbXIRXKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbXIRXKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXIRXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:10:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40788 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbXIRXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:10:12 -0400
Date: Wed, 19 Sep 2007 04:42:59 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <20070906151118.GB28565@fieldses.org>
Message-ID: <alpine.LFD.0.999.0709190432510.26241@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
 <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
 <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org>
 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in>
 <20070906151118.GB28565@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, J. Bruce Fields wrote:
> 
> On Thu, Sep 06, 2007 at 01:59:50PM +0530, Satyam Sharma wrote:
> > Oh and btw, note that we're talking of the (lack of) security of a
> > "running kernel" here -- because across reboots, there is /really/
> > *absolutely* no such thing as "kernelspace security" because the superuser
> > will simply switch the vmlinuz itself ...
> 
> Well, the machine could be booting from cdrom, and could live in a
> locked machine room.

And how is this different from the "trusted tamperproof hardware"
solution I proposed earlier? From an attack vector p.o.v. they are both
precisely the same -- both of them are designed to prevent the attacker
from gaining unfettered access to system hardware, hmm?

Oh, actually, if past history is anything to go by, then your scheme
is provably weaker. Security systems are invariably always broken at
their weakest link, which is invariably always the human/social element,
and your scheme derives its security by relying on *social* element.

To elaborate my point, what prevents me from bribing / torturing /
blackmailing whoever owns the key to that locked server room and ...

The attack is "non-technical", but hey, so was your security :-)


> Or people with root on a virtual host don't
> necessarily have the ability to replace the kernel for that host.

Again, you're restricting physical access ... but okay, this is a slightly
more plausible solution (but one that applies to only a *specific* kind of
situation).


Satyam
