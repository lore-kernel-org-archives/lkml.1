Return-Path: <linux-kernel-owner+w=401wt.eu-S1761610AbYD2WNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761610AbYD2WNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYD2WNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:13:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbYD2WNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:13:01 -0400
Date: Tue, 29 Apr 2008 15:12:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: rdunlap@xenotime.net, harvey.harrison@gmail.com, bunk@kernel.org,
       den@openvz.org, linux-pcmcia@lists.infradead.org, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: pcmcia_ioctl.c compile error
Message-Id: <20080429151233.401a9330.akpm@linux-foundation.org>
In-Reply-To: <20080429215620.GA14848@flint.arm.linux.org.uk>
References: <20080429182709.GB2898@cs181133002.pp.htv.fi>
	<20080429201704.GA31311@flint.arm.linux.org.uk>
	<20080429135902.504b6362.rdunlap@xenotime.net>
	<1209502988.24729.31.camel@brick>
	<20080429140926.bb763630.akpm@linux-foundation.org>
	<20080429141520.7a778606.rdunlap@xenotime.net>
	<20080429143824.8015c502.akpm@linux-foundation.org>
	<20080429215620.GA14848@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 22:56:20 +0100
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Tue, Apr 29, 2008 at 02:38:24PM -0700, Andrew Morton wrote:
> > On Tue, 29 Apr 2008 14:15:20 -0700
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > > > I believe Russell is referring to the removal of the ioctl, not the
> > > > > compile breakage.
> > > > > 
> > > > 
> > > > That would be interesting information (although I have a vague feeling that
> > > > it has been discussed before).
> > > 
> > > Yes:  http://lkml.org/lkml/2008/2/27/291
> > > (now that Harvey reminded me/us)
> > 
> > oh, OK, whatever, that's easy.  I dropped the old patch and queued this
> > one:
> 
> I'll spend some time this coming weekend working out precisely what it
> requires from the ioctl interface - maybe we can have a cut-down ioctl
> interface that bolts straight on as an "add on" to the new controls
> without being too invasive, while still allowing its PCMCIA bits to
> work.

umm, well,

a) as your machine still needed the ioctl code, we can assume that there
   are others out there.  So it's unclear that we _can_ delete it, or change
   its interfaces.

b) the rate of change in that code is very close to zero.  I'd say just let
   it be.  It's not a good use of one's time?

