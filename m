Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZDOR73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZDOR73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZDOR7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:59:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059AbZDOR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:59:10 -0400
Date: Wed, 15 Apr 2009 10:56:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: mmotm 2009-04-14-17-24 uploaded
Message-Id: <20090415105613.01540866.akpm@linux-foundation.org>
In-Reply-To: <22518.1239773374@turing-police.cc.vt.edu>
References: <200904150024.n3F0Ovdo019569@imap1.linux-foundation.org>
	<22518.1239773374@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 01:29:34 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 14 Apr 2009 17:24:57 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-04-14-17-24 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> patch input-add-a-dmi-table-for-the-i8042reset-option-make-msi-wind-u-100-work.patch
> is horribly busticated - was this dependent on another patch that was dropped?
> The reference to 'i8042_nonfatal' is odd, I can't find it defined anywhere in the tree.
> 
>   CC      drivers/input/serio/i8042.o
> In file included from drivers/input/serio/i8042.h:28,
>                  from drivers/input/serio/i8042.c:85:
> drivers/input/serio/i8042-x86ia64io.h:501: error: redefinition of 'i8042_dmi_reset_table'
> drivers/input/serio/i8042-x86ia64io.h:380: note: previous definition of 'i8042_dmi_reset_table' was here
> drivers/input/serio/i8042-x86ia64io.h: In function 'i8042_pnp_init':
> drivers/input/serio/i8042-x86ia64io.h:619: error: 'i8042_nonfatal' undeclared (first use in this function)
> drivers/input/serio/i8042-x86ia64io.h:619: error: (Each undeclared identifier is reported only once
> drivers/input/serio/i8042-x86ia64io.h:619: error: for each function it appears in.)
> make[2]: *** [drivers/input/serio/i8042.o] Error 1
> 

Sorry, someone merged something else and I had a big reject to fix and
I never got around to actually testing it and and and.  And Dmitry
doesn't seem very interested in the patch anyway.

I'll drop it for now - Arjan, please resend anything which you think we
still need.

Actually, it appears that I tried to get that patch into 2.6.29 and
we're now missing 2.6.30.  What's happening here?  Dmitry?

The changelog:

: From: Arjan van de Ven <arjan@linux.intel.com>
: 
: There are several DMI tables in the i8042 (keyboard) driver already, but
: not one for the i8042.reset option.  This patch adds such an option (which
: also sets the nonfatal flag so that if the reset fails, the keyboard still
: works).
: 
: Two users for this table are added as well, the MSI Wind U-100 and the LG
: X110.  The MSI Wind also needs to be in the "don't trust the pnp data" for
: the touchpad to work on my machine.

