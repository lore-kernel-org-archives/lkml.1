Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbZELGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbZELGsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755056AbZELGsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:48:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50803 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbZELGsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:48:00 -0400
Date: Tue, 12 May 2009 08:53:16 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090512065316.GD19296@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com> <877i0xib7d.fsf@basil.nowhere.org> <200905112330.20509.tobias.doerffel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905112330.20509.tobias.doerffel@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:30:19PM +0200, Tobias Doerffel wrote:
> > > diff --git a/arch/x86/include/asm/module.h
> > > b/arch/x86/include/asm/module.h index 47d6274..e959c4a 100644
> > > --- a/arch/x86/include/asm/module.h
> > > +++ b/arch/x86/include/asm/module.h
> > > @@ -28,6 +28,8 @@ struct mod_arch_specific {};
> > >  #define MODULE_PROC_FAMILY "586MMX "
> > >  #elif defined CONFIG_MCORE2
> > >  #define MODULE_PROC_FAMILY "CORE2 "
> > > +#elif defined CONFIG_MATOM
> > > +#define MODULE_PROC_FAMILY "ATOM "
> >
> > This should be obsolete anyways, you can just uses CORE2. They have
> > compatible ISAs.
> So you would recommend writing
> 
> #elif defined CONFIG_MCORE2 || defined CONFIG_ATOM
> #define MODULE_PROC_FAMILY "CORE2 "
> 
> ?

Yes.  Or maybe you can find a better name.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
