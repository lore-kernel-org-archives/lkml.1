Return-Path: <linux-kernel-owner+w=401wt.eu-S965671AbXBGHnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671AbXBGHnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 02:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965674AbXBGHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 02:43:11 -0500
Received: from koto.vergenet.net ([210.128.90.7]:57004 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965671AbXBGHnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 02:43:10 -0500
Date: Wed, 7 Feb 2007 16:33:16 +0900
From: Horms <horms@verge.net.au>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Judith Lebzelter <judith@osdl.org>, fastboot@osdl.org,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [Fastboot] [ PATCH ] fix to documentation for kexec
Message-ID: <20070207073316.GF26314@verge.net.au>
References: <20070201181955.GE5825@shell0.pdx.osdl.net> <Pine.LNX.4.64.0702011324050.16833@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702011324050.16833@CPE00045a9c397f-CM001225dbafb6>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 01:25:04PM -0500, Robert P. J. Day wrote:
> On Thu, 1 Feb 2007, Judith Lebzelter wrote:
> 
> > Hello,
> >
> > I've noticed that the boot options are not correct for in
> > the documentation for kdump. The "init" keyword is not
> > necessary, and causes a kernel panic when booting with an
> > initrd on Fedora 5.
> >
> > Thanks;
> > Judith Lebzelter
> >
> > ---
> > Signed-off-by: Judith Lebzelter <judith@osdl.org>
> > ---
> >
> >
> > Index: linux/Documentation/kdump/kdump.txt
> > ===================================================================
> > --- linux.orig/Documentation/kdump/kdump.txt
> > +++ linux/Documentation/kdump/kdump.txt
> > @@ -207,7 +207,7 @@ the following command:
> >
> >     kexec -p <dump-capture-kernel> \
> >     --initrd=<initrd-for-dump-capture-kernel> --args-linux \
> > -   --append="root=<root-dev> init 1 irqpoll"
> > +   --append="root=<root-dev> 1 irqpoll"
> >
> >
> >  Notes on loading the dump-capture kernel:
> > @@ -228,8 +228,8 @@ Notes on loading the dump-capture kernel
> >  * You must specify <root-dev> in the format corresponding to the root
> >    device name in the output of mount command.
> >
> > -* "init 1" boots the dump-capture kernel into single-user mode without
> > -  networking. If you want networking, use "init 3."
> > +* Boot parameter "1" boots the dump-capture kernel into single-user mode
> > +  without networking. If you want networking, use "3".
> 
> i'm not sure you want to totally remove those first two lines, they
> appear to talk about getting to run level 1 *from a running system*.

I think that it is refering to a kernel command line parameter,
not a shell command executed on a running system, so I think the patch
is correct in that respect.

-- 
Horms
  H: http://www.vergenet.net/~horms/
  W: http://www.valinux.co.jp/en/

