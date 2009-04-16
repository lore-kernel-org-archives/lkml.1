Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZDPCK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZDPCK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZDPCKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:10:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:61352 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbZDPCKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fasWkj9WiaKtFMxDo+Lp0IpxE+5pdp1l7UUX4Dvk0AvzCXT2WfNMybvue5A/ZibL6F
         ZQSf0tgjWPxsm3Focj5NSCSJChOLtFwu9q7XEy90eaDmUMcW/BuaGI0FnvKydLpeySy7
         FGEkoL4o6hGh0EfBqooPdBKjulErfZJgR74Wk=
Date: Wed, 15 Apr 2009 19:10:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-04-14-17-24 uploaded
Message-ID: <20090416021000.GC2413@dtor-d630.eng.vmware.com>
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org> <22518.1239773374@turing-police.cc.vt.edu> <20090415105613.01540866.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415105613.01540866.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 10:56:13AM -0700, Andrew Morton wrote:
> On Wed, 15 Apr 2009 01:29:34 -0400 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 14 Apr 2009 17:24:57 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2009-04-14-17-24 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > patch input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
> > is horribly busticated - was this dependent on another patch that was dropped?
> > The reference to 'i8042_nonfatal' is odd, I can't find it defined anywhere in the tree.
> > 
> >   CC      drivers/input/serio/i8042.o
> > In file included from drivers/input/serio/i8042.h:28,
> >                  from drivers/input/serio/i8042.c:85:
> > drivers/input/serio/i8042-x86ia64io.h:501: error: redefinition of 'i8042_dmi_reset_table'
> > drivers/input/serio/i8042-x86ia64io.h:380: note: previous definition of 'i8042_dmi_reset_table' was here
> > drivers/input/serio/i8042-x86ia64io.h: In function 'i8042_pnp_init':
> > drivers/input/serio/i8042-x86ia64io.h:619: error: 'i8042_nonfatal' undeclared (first use in this function)
> > drivers/input/serio/i8042-x86ia64io.h:619: error: (Each undeclared identifier is reported only once
> > drivers/input/serio/i8042-x86ia64io.h:619: error: for each function it appears in.)
> > make[2]: *** [drivers/input/serio/i8042.o] Error 1
> > 
> 
> Sorry, someone merged something else and I had a big reject to fix and
> I never got around to actually testing it and and and.  And Dmitry
> doesn't seem very interested in the patch anyway.
> 
> I'll drop it for now - Arjan, please resend anything which you think we
> still need.
> 
> Actually, it appears that I tried to get that patch into 2.6.29 and
> we're now missing 2.6.30.  What's happening here?  Dmitry?
> 

I had some concerns but they have been resolved after I had a chance to
talk to Arjan at the collaboration summit. The patch (both paches,
actually), in a bit modified form, is in my 'next' branch and I am
planning to ask Linus to pull it with the other small fixes in the next
day or so.

-- 
Dmitry
