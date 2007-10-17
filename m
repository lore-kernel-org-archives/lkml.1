Return-Path: <linux-kernel-owner+w=401wt.eu-S1761771AbXJQT0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761771AbXJQT0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXJQT0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:26:34 -0400
Received: from www.tglx.de ([62.245.132.106]:33050 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbXJQT0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:26:34 -0400
Date: Wed, 17 Oct 2007 21:25:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: "Denis V. Lunev" <den@openvz.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] .gitignore update for x86 arch
In-Reply-To: <20071017192149.GD11837@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0710172125340.24155@localhost.localdomain>
References: <20071016072221.GA14029@iris.sw.ru> <20071017192149.GD11837@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Sam Ravnborg wrote:

> Hi Thomas.
> 
> Another one I expect you to take in your x86 tree - OK?

Thanks, applied
 
	tglx

> 	Sam
> 
> On Tue, Oct 16, 2007 at 11:22:21AM +0400, Denis V. Lunev wrote:
> > This patch:
> > - makes .gitignore files visible to git
> > - makes arch/x86/kernel/vsyscall_32.lds and arch/i386/boot invisible
> > 
> > Signed-off-by: Denis V. Lunev <den@openvz.org>
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 27c3e83..22fb8fa 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -26,6 +26,7 @@ vmlinux*
> >  !vmlinux.lds.S
> >  System.map
> >  Module.symvers
> > +!.gitignore
> >  
> >  #
> >  # Generated include files
> > diff --git a/arch/i386/.gitignore b/arch/i386/.gitignore
> > new file mode 100644
> > index 0000000..36ef4c3
> > --- /dev/null
> > +++ b/arch/i386/.gitignore
> > @@ -0,0 +1 @@
> > +boot
> > diff --git a/arch/x86/kernel/.gitignore b/arch/x86/kernel/.gitignore
> > index 40836ad..4ea38a3 100644
> > --- a/arch/x86/kernel/.gitignore
> > +++ b/arch/x86/kernel/.gitignore
> > @@ -1 +1,2 @@
> >  vsyscall.lds
> > +vsyscall_32.lds
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
