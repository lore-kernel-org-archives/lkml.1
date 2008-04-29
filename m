Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYD2VKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYD2VKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762899AbYD2VJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:09:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762815AbYD2VJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:09:51 -0400
Date: Tue, 29 Apr 2008 14:09:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: rdunlap@xenotime.net, rmk+lkml@arm.linux.org.uk, bunk@kernel.org,
       den@openvz.org, linux-pcmcia@lists.infradead.org, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429140926.bb763630.akpm@linux-foundation.org>
In-Reply-To: <1209502988.24729.31.camel@brick>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<1209502988.24729.31.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:03:07 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Tue, 2008-04-29 at 13:59 -0700, Randy Dunlap wrote:
> > On Tue, 29 Apr 2008 21:17:04 +0100 Russell King wrote:
> > 
> > > On Tue, Apr 29, 2008 at 09:27:10PM +0300, Adrian Bunk wrote:
> > > > Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> > > > came through -mm that contains a patch implementing the overdue removal 
> > > > of the PCMCIA control ioctl that did not yet make it into Linus' tree:
> > > 
> > > Okay, this means at least one of my platforms is now dead as far as
> > > building new kernels for it, and nothing I can do about that.  Ho hum.
> > 
> > I don't get it.  Several of us had building problems for a few
> > days with some pasic driver.  We posted some bug reports and
> > some patches, but we put up with it for a few days...
> > 
> 
> I believe Russell is referring to the removal of the ioctl, not the
> compile breakage.
> 

That would be interesting information (although I have a vague feeling that
it has been discussed before).

I've been sitting on pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch for
over a year, mainly waiting for Dominik to reappear and decide what to do
about it.

I could just drop it, shrug.
