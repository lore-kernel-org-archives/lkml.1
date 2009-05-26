Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZEZRbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZEZRbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbZEZRbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:31:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZEZRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:31:37 -0400
Date: Tue, 26 May 2009 14:31:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mundt <lethal@linux-sh.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH -next] v4l2: handle unregister for non-I2C builds
Message-ID: <20090526143110.6c7b2e5a@pedra.chehab.org>
In-Reply-To: <20090522175554.19465733.sfr@canb.auug.org.au>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
	<4A085455.5040108@oracle.com>
	<20090522054847.GB14059@linux-sh.org>
	<20090522175554.19465733.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 22 May 2009 17:55:54 +1000
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> On Fri, 22 May 2009 14:48:47 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
> >
> > On Mon, May 11, 2009 at 09:37:41AM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Build fails when CONFIG_I2C=n, so handle that case in the if block:
> > > 
> > > drivers/built-in.o: In function `v4l2_device_unregister':
> > > (.text+0x157821): undefined reference to `i2c_unregister_device'
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > This patch still has not been applied as far as I can tell, and builds
> > are still broken as a result, almost 2 weeks after the fact.
> 
> In fact there has been no updates to the v4l-dvb tree at all since
> May 11.  Mauro?

Sorry, this email were got by a wrong filtering rule here. Only today I
noticed it.

Anyway, the tree were updated yesterday, with Randy's patch. Sorry for the mess.
> 
> I have reverted the patch that caused the build breakage ... (commit
> d5bc7940d39649210f1affac1fa32f253cc45a81 "V4L/DVB (11673): v4l2-device:
> unregister i2c_clients when unregistering the v4l2_device").
> 
> [By the way, an alternative fix might be to just define
> V4L2_SUBDEV_FL_IS_I2C to be zero if CONFIG_I2C and CONFIG_I2C_MODULE are
> not defined (gcc should then just elide the offending code).]




Cheers,
Mauro
