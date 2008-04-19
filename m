Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbYDSO77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbYDSO77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYDSO7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:59:52 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:64945 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbYDSO7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mWpA0KoJCKEIncufulLqc4ScZIuvfi7LcO9z3Lha7rm6YIliB3x71BbN3hR4gs5AoLnZNsyDB54Y0DRi11L94bd/0+AvnafxkcnYYteI9g/mihZyJ7Z7/T2nB1OHFIBIl15bPnCHPzD9Ps0ODpnktHnp9GBGpyDlxQbp6c6FrVQ=
Date: Sat, 19 Apr 2008 09:59:48 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080419145948.GA4528@lintop>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419142329.GA5339@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 04:23:29PM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > >  config 4KSTACKS
> > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > -	depends on DEBUG_KERNEL
> > >  	depends on X86_32
> > > +	default y
> > 
> > This patch will cause kernels to crash.
> 
> what mainline kernels crash and how will they crash? Fedora and other 
> distros have had 4K stacks enabled for years:

If by other distros you mean RHEL then yes.  However, openSUSE,
Ubuntu, and Mandriva all still have 8K stacks.  I know of no other
distributions that default to 4K.

--
Shawn
