Return-Path: <linux-kernel-owner+w=401wt.eu-S1161109AbXBHW6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109AbXBHW6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 17:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161520AbXBHW6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 17:58:52 -0500
Received: from ozlabs.org ([203.10.76.45]:34784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161109AbXBHW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 17:58:51 -0500
To: Horms <horms@verge.net.au>
cc: Andrew Morton <akpm@osdl.org>, Al Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org
From: Michael Neuling <mikey@neuling.org>
Subject: Re: [Fastboot] [PATCH] free initrds boot option 
In-reply-to: <20070208123537.GB7304@verge.net.au> 
References: <4410.1165450723@neuling.org> <20061206163021.f434f09b.akpm@osdl.org> <4577624A.6010008@zytor.com> <13639.1165462578@neuling.org> <20061207164756.GA13873@in.ibm.com> <45788A56.9010706@us.ibm.com> <30054.1165534335@neuling.org> <20061213013506.GB22902@verge.net.au> <20070208123537.GB7304@verge.net.au>
Comments: In-reply-to Horms <horms@verge.net.au>
   message dated "Thu, 08 Feb 2007 21:35:39 +0900."
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 21.4.1
Date: Fri, 09 Feb 2007 09:58:39 +1100
Message-ID: <15804.1170975519@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20070208123537.GB7304@verge.net.au> you wrote:
> On Wed, Dec 13, 2006 at 10:35:08AM +0900, Horms wrote:
> > On Fri, Dec 08, 2006 at 10:32:15AM +1100, Michael Neuling wrote:
> > > > >Is there a kexec-tools patch too? How does second kernel know about
> > > > >the location of the first kernel's initrd to be reused?
> > > > >  
> > > > >
> > > > kexec-tools has to be modified to pass the first kernel initrd. On 
> > > > powerpc, initrd locations are exported using device-tree. At present, 
> > > > kexec-tool ignores the first kernel initrd property values and creates 
> > > > new initrd properties if the user passes '--initrd' option to the kexec
 
> > > > command. So, will be an issue unless first kernel device-tree is passed
 
> > > > as buffer.
> > > 
> > > We've been using the --devicetreeblob kexec-tools option available for
> > > POWERPC.  This enables you to setup the device tree (and hence, the
> > > initrd points) as you like.
> > > 
> > > I'm happy to put together a patch for kexec-tools. 
> > 
> > Please do. And please cc me on a copy that applies against kexec-tools-test
ing.
> > 
> > > Unfortunately this
> > > is arch specific.  A quick look through the x86, ia64, s390 and ppc64
> > > code shows the --initrd option for all these just reads the specified
> > > initrd file, pushes it out to memory and uses the base and size pointers
> > > to setup the next boot.  We'd obviously just skip to the last stage.
> > > 
> > > So what's the kexec-tools option called?  --initrd-location <base> <size>
?
> > 
> > That sounds fine to me. I think its ok to make it arch specific for
> > starters and then move it out to generic code later. That said, if
> > you're feeling particularly entergetic, feel free to do the generic
> > stuff now and just add null stubs for the other architectures (does
> > that makes sense?).
> 
> Did anything ever come of this?

Not yet, but it's on my todo list.  

Mikey
