Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbZEZXW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbZEZXW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759941AbZEZXUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:20:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760000AbZEZXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:20:03 -0400
Date: Tue, 26 May 2009 18:25:11 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 17/38] groups: move code to kernel/groups.c
Message-ID: <20090526232511.GA23806@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-17-git-send-email-adobriyan@gmail.com> <20090526144819.GA21502@hallyn.com> <20090526183405.GA11909@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526183405.GA11909@x200.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> On Tue, May 26, 2009 at 09:48:19AM -0500, Serge E. Hallyn wrote:
> > Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > > Move supplementary groups implementation to kernel/groups.c .
> > > kernel/sys.c already accumulated quite a few random stuff.
> > > 
> > > Do strictly copy/paste + add required headers to compile.
> > > Compile-tested on many configs and archs.
> > > 
> > > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > 
> > Actually I needed the following change:
> 
> This is dealt by first patch:
> "[PATCH 01/38] cred: #include init.h in cred.h"
> which is in -mm already.
> 
> > --- a/kernel/groups.c
> > +++ b/kernel/groups.c
> > @@ -1,6 +1,7 @@
> >  /*
> >   * Supplementary group IDs
> >   */
> > +#include <linux/init.h>
> 
> Wrong, groups.c doesn't use __init at all.

Right you are.

thanks,
-serge
