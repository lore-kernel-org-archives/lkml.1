Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYHGUL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYHGUL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYHGULQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:11:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:50150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbYHGULP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:11:15 -0400
Date: Thu, 7 Aug 2008 22:11:06 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Keith Owens <kaos@ocs.com.au>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080807221106.734a8da3@kopernikus.site>
In-Reply-To: <20080807200944.GK24801@one.firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com>
	<200808060133.10457.nickpiggin@yahoo.com.au>
	<87r6926dsr.fsf@basil.nowhere.org>
	<200808061550.22996.nickpiggin@yahoo.com.au>
	<489B34BA.4060300@linux-foundation.org>
	<489B3A0D.7060706@s5r6.in-berlin.de>
	<489B48BF.3060609@linux-foundation.org>
	<489B5149.4030600@sgi.com>
	<20080807200659.GJ24801@one.firstfloor.org>
	<20080807220737.23e29d46@kopernikus.site>
	<20080807200944.GK24801@one.firstfloor.org>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2008-08-07 22:09]:
>
> On Thu, Aug 07, 2008 at 10:07:37PM +0200, Bernhard Walle wrote:
> > * Andi Kleen <andi@firstfloor.org> [2008-08-07 22:06]:
> > >
> > > > To merge KDB or any other RAS tools, you need to deal with kdump. Kdump
> > > > hijack panic() before the die calling chain. For KDB or a RAS tool to
> > > 
> > > Imho kdump should just be fixed to use die chains.
> > 
> > Well, we had that discussion several times. I'm not against it
> > (instead, I would like it), but I don't think that repeating the
> > discussion over and over does help ...
> 
> Just needs some code? 

No, it was rejected with the argument that in panic case, as less code
as possible should be executed before kexec'ing the panic kernel.

See also: http://kerneltrap.org/node/14050 (for example)



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
