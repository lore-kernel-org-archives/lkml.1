Return-Path: <linux-kernel-owner+w=401wt.eu-S1422936AbXBHIdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422936AbXBHIdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422981AbXBHIdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:33:05 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:53378 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1422936AbXBHIdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:33:03 -0500
Date: Thu, 8 Feb 2007 00:18:11 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Mark Lord <lkml@rtr.ca>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <45C89BC1.9010703@rtr.ca>
Message-ID: <Pine.LNX.4.63.0702080011160.2981@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> 
 <20070205084523.GA21858@elte.hu>  <1170682488.29759.795.camel@pmac.infradead.org>
  <20070205155627.GA8354@elte.hu>  <1170692539.29759.856.camel@pmac.infradead.org>
  <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu> 
 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org> 
 <1170710272.29759.894.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org> 
 <1170711587.29759.909.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org> 
 <1170712393.29759.925.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702051409110.8424@woody.linux-foundation.org> 
 <20070205143110.fca62b57.randy.dunlap@oracle.com> 
 <Pine.LNX.4.64.0702051502370.8424@woody.linux-foundation.org>
 <45C89BC1.9010703@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Mark Lord wrote:

> I'm with Linus 100% here.
>
> It's really irritating to upgrade to a newer kernel,
> using the same old .config file, and then discover that
> my MythTV box no longer auto-boots to record programs.
>
> The reason being, that /proc/acpi/alarm no longer exists,
> and the kernel option to configure it has mysteriously
> disappeared from the menus.
>
> After an hour of hand examining and grep'ing Kconfig files,
> I eventually find the secret little totally-unrelated option
> that has to be selected to make the ACPI alarm option visible
> again.
>
> Doh!
>
> That interface is driven entirely backwards.
> The funtionality option should always be visible,
> and should "select" (or hey, invent a better mechanism,
> I'm not fussy), the underlying crap required to let me use it.

I've been compiling and deploying kernels since 0.99 days, and I still get bit 
by this sort of thing. This is one of the reasons why I've liked the minimal 
config option that Rob Landley has proposed a few times wher eyou specify the 
things that you need and let the build system put in the nessasary dependancies.

I started out useing menuconfig, used the TCL based xconfig, but went back to 
menuconfig when the new xconfig came out (I now do most of my kernel compiles on 
remote machines that I may or may not have X access to anyway)

especially if a particular driver/feature doesn't want to compile, tracking down 
how to turn it off can be a pain. The idea that Alan posted of saying 'disabling 
this function will disable the following things as well' would be an extremely 
useful enhancement.

I think that there are more of us out here that configure and compile kernels, 
but aren't kernel hackers then most people (especialy the distros) want to 
admit. (and for that matter, many of the distro support policies activly 
discourage people from telling the distro when they compile a kernel)

David Lang
