Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbXJZOnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbXJZOnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXJZOnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:43:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXJZOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:43:24 -0400
Date: Fri, 26 Oct 2007 07:39:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
Message-ID: <20071026073926.25dc56dc@laptopd505.fenrus.org>
In-Reply-To: <20071026062336.GA19253@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org>
	<alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
	<20071026062336.GA19253@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
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

that's the worst of all things to do... either make a change in ONE go,
when you do all the changes anyway (users will remmeber 2.6.24 was the
unification kernel, but 2.6.25 breaking stuff will be a total
surprise)... or keep them around forever. As long as it works, nobody
will change the scripts.
