Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYB0KCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYB0KCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYB0KCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:02:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:39079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750860AbYB0KCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:02:01 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+q8OA+IpWqpOUTQpZ4bp8E9GXuzEZvXGT2ZO+CNB
	q2tWfcc9UZU5eG
Date: Wed, 27 Feb 2008 11:02:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bernd Petrovitsch <bernd@firmix.at>
cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, ricknu-0@student.ltu.se,
       khc@pm.waw.pl, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
In-Reply-To: <1204104420.17396.2.camel@tara.firmix.at>
Message-ID: <Pine.LNX.4.64.0802271059490.5059@axis700.grange>
References: <1204062430.47c488def40a4@portal.student.luth.se> 
 <20080226135444.f83a0536.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr> 
 <Pine.LNX.4.64.0802270033310.5714@axis700.grange> <1204104420.17396.2.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Bernd Petrovitsch wrote:

> On Mit, 2008-02-27 at 00:40 +0100, Guennadi Liakhovetski wrote:
> > On Tue, 26 Feb 2008, Jan Engelhardt wrote:
> > 
> > > +Continuation lines are always shorter than the initial one and are
> > > +(1) indented as much as the initial line, plus (2) alignment spaces.
> > > +Spaces are used so as to not cause odd aligning for users wishing to
> > > +display tabs at sizes other than 8. In the example below, the
> > > +continuation line of the printk call therefore has two tabs of logical
> > > +indent, followed by a number of spaces to align it up.
> > 
> > Now, I think, I am not the only one using emacs. Until now the "linux" 
> > C-style fitted perfectly with the CodingStyle, now it no longer will. 
> > Namely, emacs puts as many tabs to indent the continuation line as fit 
> > (i.e., at tab width = 8 spaces it's just (extra indent / 8) tabs plus 
> > (extra indent % 8) spaces. Is there a way to make emacs behave compatibly 
> > to this proposal? If not, I would not like to have to re-indent every such 
> 
> Unless I'm misunderstanding something completely: Add "indent-tabs-mode:
> nil" in a "Local Variables:" section.
> But since Linux-style has that since ages (if not ever), that should be
> set for am emacs'ens linux-mode anyway.

I think you do misunderstand something. The "linux" emacs mode as I know 
it does for the following example

1:	function(arg1,
2:		 arg2);

in line 2 two TABs and one space. Whereas the proposal in discussion wants 
to have there one TAB and nine spaces.

Thanks
Guennadi
---
Guennadi Liakhovetski
