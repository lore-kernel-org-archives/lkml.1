Return-Path: <linux-kernel-owner+w=401wt.eu-S1758122AbYD2VPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbYD2VPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYD2VPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:15:31 -0400
Received: from xenotime.net ([66.160.160.81]:56643 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752715AbYD2VPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:15:30 -0400
Date: Tue, 29 Apr 2008 14:15:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, rdunlap@xenotime.net,
       rmk+lkml@arm.linux.org.uk, bunk@kernel.org, den@openvz.org,
       linux-pcmcia@lists.infradead.org, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429141520.7a778606.rdunlap@xenotime.net>
In-Reply-To: <20080429140926.bb763630.akpm@linux-foundation.org>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<1209502988.24729.31.camel@brick>
	<20080429140926.bb763630.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 14:09:26 -0700 Andrew Morton wrote:

> On Tue, 29 Apr 2008 14:03:07 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > On Tue, 2008-04-29 at 13:59 -0700, Randy Dunlap wrote:
> > > On Tue, 29 Apr 2008 21:17:04 +0100 Russell King wrote:
> > > 
> > > > On Tue, Apr 29, 2008 at 09:27:10PM +0300, Adrian Bunk wrote:
> > > > > Commit 9c37066d888bf6e1b96ad12304971b3ddeabbad0 (proc: remove proc_bus) 
> > > > > came through -mm that contains a patch implementing the overdue removal 
> > > > > of the PCMCIA control ioctl that did not yet make it into Linus' tree:
> > > > 
> > > > Okay, this means at least one of my platforms is now dead as far as
> > > > building new kernels for it, and nothing I can do about that.  Ho hum.
> > > 
> > > I don't get it.  Several of us had building problems for a few
> > > days with some pasic driver.  We posted some bug reports and
> > > some patches, but we put up with it for a few days...
> > > 
> > 
> > I believe Russell is referring to the removal of the ioctl, not the
> > compile breakage.
> > 
> 
> That would be interesting information (although I have a vague feeling that
> it has been discussed before).

Yes:  http://lkml.org/lkml/2008/2/27/291
(now that Harvey reminded me/us)


> I've been sitting on pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch for
> over a year, mainly waiting for Dominik to reappear and decide what to do
> about it.
> 
> I could just drop it, shrug.


---
~Randy
