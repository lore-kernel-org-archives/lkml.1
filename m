Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXJZL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXJZL7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXJZL7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:59:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58670 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753591AbXJZL7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:59:05 -0400
Date: Fri, 26 Oct 2007 13:01:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
Message-ID: <20071026130125.78ea7017@the-village.bc.nu>
In-Reply-To: <20071026062336.GA19253@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
	<alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
	<20071026062336.GA19253@uranus.ravnborg.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 08:23:36 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, Oct 25, 2007 at 10:17:53PM +0200, Thomas Gleixner wrote:
> > 
> > I think the last remaining bit to cleanup is the symlink from
> > arch/x86/boot/bzImage. Now that the old directories are gone it does
> > not make much sense to keep them alive. Andrew will survive it :)
> 
> It is not just Andrew I'm afraid.
> We got a Debian bug-report too when we did not have the symlink and I
> asume this is true for several others.
> We should let it stay in 2.6.24 and remove the symlink for 2.6.25 IMO.

I would put it on the list and leave it for a couple of years so that
people using old distros have all upgraded at that point. Adrian will
remember to delete it if its on the list to go ....
