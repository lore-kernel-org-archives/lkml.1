Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbXJWPKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbXJWPKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXJWPKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:10:32 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46467 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbXJWPKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:10:31 -0400
Date: Tue, 23 Oct 2007 17:11:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Al Viro <viro@ftp.linux.org.uk>, WANG Cong <xiyou.wangcong@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071023151059.GU30533@stusta.de>
References: <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de> <20071023131009.GA32298@elte.hu> <p73sl427wvu.fsf@bingen.suse.de> <20071023142006.GA9961@elte.hu> <471E05C0.4010005@goop.org> <20071023144710.GA13785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071023144710.GA13785@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 04:47:10PM +0200, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > Ingo Molnar wrote:
> > > * Andi Kleen <andi@firstfloor.org> wrote:
> > >
> > >   
> > >>>> You should rename it then to "asmcall" or something.
> > >>>>         
> > >>> if then that should be a separate renaming patch.
> > >>>       
> > >> Well you're asking for the ugly hacks for out of tree code.  [...]
> > >>     
> > >
> > > nice word-bending there. I'm asking for pre-existing annotations to 
> > > survive. It hurts you _nothing_ and it was a world of pain for us to 
> > > recover those lost annotations. Anyway, if Jeremy does not object to the 
> > > patch
> > 
> > I don't have any objections to the idea of the patch, but I'm still 
> > concerned about the practical aspects of it.  Maintaining these kinds 
> > of annotations is hard/fragile/etc when the compiler doesn't warn when 
> > you get it wrong, and only a very specific use-case will reveal the 
> > problem (and do so in a fairly obscure way).
> 
> it wont be any different from the situation before - we had no such 
> warnings there either. Anyway, this shouldnt really bother you as at the 
> moment it's only used for -rt. The issue is to keep something we had 
> before (but which was stupidly/carelessly removed). If it breaks we'll 
> fix it up.
>...

Until recently (read: before 2.6.20) fastcall had a semantics on i386
that resulted in compile errors if you got it wrong.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

