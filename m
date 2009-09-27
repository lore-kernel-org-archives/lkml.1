Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730AbZI0Gls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbZI0Gls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 02:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZI0Glr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 02:41:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53778 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZI0Glr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 02:41:47 -0400
Subject: Re: how best to report results of my kernel tree scanning scripts?
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0909260841530.19382@localhost>
References: <alpine.LFD.2.00.0909260811470.19017@localhost>
	 <1253968675.4568.3.camel@ht.satnam>
	 <alpine.LFD.2.00.0909260841530.19382@localhost>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 12:11:19 +0530
Message-Id: <1254033679.4285.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Sat, 2009-09-26 at 08:44 -0400, Robert P. J. Day wrote:
> On Sat, 26 Sep 2009, Jaswinder Singh Rajput wrote:
> 
> > Hello Robert,
> >
> > On Sat, 2009-09-26 at 08:16 -0400, Robert P. J. Day wrote:
> > > since the merge window appears to be ready to close fairly soon(?),
> > > i'm prepping to run my scanning scripts once again to identify (among
> > > other things):
> > >
> > >   * unused Kconfig CONFIG variables
> > >   * references to CONFIG_ variables that don't even exist (both in
> > >     source files and Makefiles)
> > >   * references to non-existent header files
> > >
> > > and bunches of other things.  i'm open as to the best way to post the
> > > results, since different people have different opinions.
> > >
> > >   and, no, i can't just submit patches since, in many cases, i have no
> > > idea what the fix should be (if any) -- that's the kind of decision
> > > best left to the respective subsystem maintainers.
> > >
> > >   thoughts?  this is where i put the old output:
> > >
> > > http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup
> > >
> >
> > Thanks for reporting these results, I will try to fix them and submit
> > patches with Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
>   keep in mind that those are *old* results (although, of course, some
> of it will still be relevant).  i'll update those pages as soon as
> -rc1 is out.  unsurprisingly, some of that is historical cruft that's
> been around a *looooong* time.  very little of it represents actual
> breakage but, occasionally, those scans will reveal actual typoes.
> 

For http://www.crashcourse.ca/wiki/index.php/Unused_CONFIG_variables :

I send following patches which looks relevant to me :
0001-alpha-Remove-unused-CONFIG-ALPHA_EV7.patch
0002-ARM-Remove-unused-CONFIG-ARCH_AT91SAM9260_SAM9XE.patch
0003-ARM-Remove-unused-CONFIG-reference-DEBUG_S3C_PORT.patch
0004-ARM-OMAP-Remove-unused-CONFIG-MACH_OMAP_HTCWIZARD.patch
0005-ARM-Remove-unused-CONFIG-SA1100_H3XXX.patch
0006-x86-SLUB-Remove-unused-CONFIG-FAST_CMPXCHG_LOCAL.patch
0007-xtensa-Remove-unused-CONFIG-XTENSA_ISS_NETWORK-and.patch
0008-isdn-Fix-HISAX_DE_AOC-it-should-be-CONFIG_DE_AOC.patch

For http://www.crashcourse.ca/wiki/index.php/Badref_CONFIG_variables
http://www.crashcourse.ca/wiki/index.php/Badref_make_CONFIG_variables
http://www.crashcourse.ca/wiki/index.php/Badref_linux_header_files

Enough information is not present because we need to make Kconfig
entries or so. So I request you to send these information to respective
maintainers so that they can fix it.

And if you provide these scripts to Sam (also Cc) then he will make some
option line 'make configcheck' so that other developers can also take
advantages of your scripts.

For http://www.crashcourse.ca/wiki/index.php/The_style_script :

I think Julia (also Cc) and some janitors (also Cc) are already working
on few points.

If you also provide these scripts to Sam, then we can also take
advantage of it.

Thanks,
--
JSR

