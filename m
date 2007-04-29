Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXD2IGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXD2IGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932812AbXD2IGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:06:43 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:43633 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbXD2IFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:05:45 -0400
Date: Sun, 29 Apr 2007 10:05:17 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Timur Tabi <timur@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.21-rc7-mm2
In-Reply-To: <20070426134631.7a78b946.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0704291004420.27246@anakin>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <46309142.2010907@googlemail.com> <20070426133720.25085207.akpm@linux-foundation.org>
 <20070426134631.7a78b946.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Randy Dunlap wrote:
> On Thu, 26 Apr 2007 13:37:20 -0700 Andrew Morton wrote:
> > On Thu, 26 Apr 2007 13:47:14 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> > > Andrew Morton wrote:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
> > > >
> > > >
> > > > - this has everything which is in 2.6.21.  Plus more!
> > > >
> > > > - a number of nasty bugs were fixed.  This should be (a lot) more stable
> > > >   than 2.6.21-rc7-mm1.
> > > >
> > > >   
> > > 
> > > I get this warning here :
> > > 
> > > 
> > > drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
> > > 'UCC_GETH' refer to undefined symbol 'UCC_FAST'
> > 
> > Yes, we get so many of those that I tend to ignore them, assuming that
> > someone will pick it up and fix it.
> > 
> > This one was added by git-powerpc, presumably
> > 7d776cb596994219584257eb5956b87628e5deaf "QE: automatically select QE
> > options"
> 
> There was a similar problem with PS3_xyz (don't recall exactly
> which PS3_option it was) that was "solved" by introducing an
> intermediate config symbol IIRC.  Maybe that trick^W fix can be
> done here also...

CONFIG_PS3_ADVANCED, commit 3f555c700b6c90f9ac24bc81a4f509583d906278

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------------------- Sint-Stevens-Woluwestraat 55
Voice +32-2-2908453 Fax +32-2-7262686 ---------------- B-1130 Brussels, Belgium
