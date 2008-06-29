Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbYF2Lno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbYF2Lno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbYF2Lnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 07:43:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbYF2Lnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 07:43:32 -0400
Date: Sun, 29 Jun 2008 08:43:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 24 - missing files in
 drivers/media/dvb/
Message-ID: <20080629084317.3392dac9@gaivota>
In-Reply-To: <20080625134859.6bc218c4.sfr@canb.auug.org.au>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au>
	<486134B4.4050400@linux.vnet.ibm.com>
	<20080625132810.6f31b571.sfr@canb.auug.org.au>
	<20080625134859.6bc218c4.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 13:48:59 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Mauro,
> 
> On Wed, 25 Jun 2008 13:28:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Tue, 24 Jun 2008 23:23:56 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > >
> > > allyesconfig kernel build on next-20080624, fails due to missing files
> > > 
> > > drivers/media/video/em28xx/em28xx-dvb.c:30:22: error: drx397xD.h: No such file or directory
> > 
> > To fix this, I have reverted commit
> > 969ff74e0ab707801150dc83eb254794bc574442 ("V4L/DVB (8006): em28xx: Split
> > HVR900 into two separate entries") from linux-next for today.
> 
> Although, on reflection, this may have been caused by the mismerge
> yesterday.  I will leave it in tomorrow unless I am told otherwise.

Thanks for the report. I've fixed the two reported issues and now it should compile fine.

Cheers,
Mauro
