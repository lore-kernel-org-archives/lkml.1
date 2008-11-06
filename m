Return-Path: <linux-kernel-owner+w=401wt.eu-S1750861AbYKFSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750861AbYKFSMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYKFSMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:12:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57626 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750733AbYKFSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:12:08 -0500
Date: Thu, 6 Nov 2008 19:11:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/15] x86: Emergency virtualization disable function
Message-ID: <20081106181159.GB1642@ucw.cz>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <1225915018-6548-10-git-send-email-ehabkost@redhat.com> <20081105222731.GA14202@elf.ucw.cz> <20081106153405.GS5247@blackpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106153405.GS5247@blackpad>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > --- /dev/null
> > > +++ b/arch/x86/kernel/virtext.c
> > > @@ -0,0 +1,89 @@
> > > +/* Core CPU virtualization extensions handling
> > > + *
> > > + * This should carry the code for handling CPU virtualization extensions
> > > + * that needs to live in the kernel core.
> > > + *
> > > + * Author: Eduardo Habkost <ehabkost@redhat.com>
> > > + *
> > > + * Copyright (C) 2008, Red Hat Inc.
> > > + */
> > 
> > GPL?
> 
> Yes, of course.
> 
> As IANAL, I used a similar .c file as reference for the author/copyright
> info header, and used arch/x86/kernel/crash.c, that doesn't refer to
> the GPL also. I think I chose a bad example as reference.
> 
> arch/x86/kernel/crash.c even has "All rights reserved". Ouch.

Yep, that should be fixed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
