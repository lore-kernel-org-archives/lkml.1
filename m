Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbXIRXYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbXIRXYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 19:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbXIRXYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 19:24:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51865 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbXIRXYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 19:24:40 -0400
Date: Wed, 19 Sep 2007 04:57:30 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <20070907153408.GG24638@fieldses.org>
Message-ID: <alpine.LFD.0.999.0709190443240.26241@enigma.security.iitk.ac.in>
References: <1188484155.6755.38.camel@heimdal.trondhjem.org>
 <1188484337.6755.41.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
 <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org>
 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
 <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in>
 <20070906151118.GB28565@fieldses.org> <1189120910.6672.30.camel@heimdal.trondhjem.org>
 <1189121572.6672.36.camel@heimdal.trondhjem.org>
 <20070907153408.GG24638@fieldses.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Sep 2007, J. Bruce Fields wrote:
> 
> On Fri, Sep 07, 2007 at 01:32:52AM +0200, Trond Myklebust wrote:
> > Sorry. Of course, you have to copy the entire /lib, etc. onto the tmpfs,
> > but you get the gist....
> > 
> > The point is that it is easy to subvert userspace if you have enough
> > privileges. In the above example it may not be entirely undetectable,
> > but who here is running a script on every login to check that / is
> > indeed uncompromised?
> 
> I suppose this is the motivation for things like the "secure attention
> key"?
> 
> But I'm most curious actually about to what degree the kernel itself is
> vulnerable to root (without a reboot).  Is disabling /dev/kmem and
> module-loading in theory enough?

No, not in theory, not in practice. But yeah, restricting an attacker's
ability to hack hardware (by controlling physical access) does take out a
whole class of attack vectors.

But, seriously, such discussion has the tendency to quickly get toooo
theoretical (thus losing practical significance). For example, would we
not also need to prevent the (userspace) superuser from being able to run
arbitrary executables that can modify firmware? Okay, let's say we have
a kernelspace infrastructure of verifying cryptographic signatures on
binaries before executing them ... but how practical/usable is this?
How practically/universally applicable is a system whose security derives
from keeping machines behind locked doors and protected by incorruptible,
armed guard?

Overall, I tend to be unenthusiastic about most schemes that claim to
have solved the user-kernel security problem (with no loss of usability/
practicality).
