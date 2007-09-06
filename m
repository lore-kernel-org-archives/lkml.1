Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbXIFIQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbXIFIQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 04:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbXIFIQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 04:16:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51487 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXIFIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 04:16:40 -0400
Date: Thu, 6 Sep 2007 13:59:50 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: NFS4 authentification / fsuid
In-Reply-To: <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
 <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org>
 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
 <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org>
 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Sep 2007, Satyam Sharma wrote:
> 
> On Thu, 30 Aug 2007, J. Bruce Fields wrote:
> 
> > On Thu, Aug 30, 2007 at 11:04:00AM -0400, Trond Myklebust wrote:
> > 
> > > What I'm saying is that the superuser can pretty much do whatever it
> > > takes to grab either your kerberos password (e.g. install a keyboard
> > > listener), a stored credential (read the contents of your kerberos
> > > on-disk credential cache), or s/he can access the cached contents of the
> > > file by hunting through /dev/kmem.
> > > 
> > > IOW: There is no such thing as security on a root-compromised machine.
> > 
> > And in theory a kernel could provide *some* guarantees against root,
> > right?  (Is there some reason a unix-like kernel must provide such
> > things as /dev/kmem?)
> 
> /dev/kmem was just an example -- IMHO differentiating between kernel and
> userspace from a security p.o.v. is always tricky. Like Trond said, there
> are very high number of ways in which privileged userspace can compromise
> a running kernel if it really wants to do that, root-is-God has always
    ^^^^^^^^^^^^^^

Oh and btw, note that we're talking of the (lack of) security of a
"running kernel" here -- because across reboots, there is /really/
*absolutely* no such thing as "kernelspace security" because the superuser
will simply switch the vmlinuz itself ...


> been *the* major problem with Unix :-)
> 
> The only _real_ way a kernel can lock itself completely against malicious
> userspace involves trusted tamperproof hardware, but even that only if
> you can get yourself to believe such a thing exists in the first place ;-)
