Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYEDNvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYEDNvu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 09:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbYEDNvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 09:51:42 -0400
Received: from mail.queued.net ([207.210.101.209]:4290 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYEDNvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 09:51:41 -0400
Date: Sun, 4 May 2008 09:55:12 -0400
From: Andres Salomon <dilinger@queued.net>
To: cbouatmailru@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] power_supply: Support serial number and ACR in
 olpc_battery
Message-ID: <20080504095512.63d36ccc@ephemeral>
In-Reply-To: <20080504093627.GA27950@zarina>
References: <20080430163002.3c768ae0@ephemeral>
	<20080502225849.GA26024@zarina>
	<20080504013142.03c8ad0b@ephemeral>
	<20080504093627.GA27950@zarina>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008 13:36:27 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Sun, May 04, 2008 at 01:31:42AM -0400, Andres Salomon wrote:
> > On Sat, 3 May 2008 02:58:49 +0400
> > Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > 
> > > On Wed, Apr 30, 2008 at 04:30:02PM -0400, Andres Salomon wrote:
> > > > From: David Woodhouse <dwmw2@infradead.org>
> > > > 
> > > > This adds serial number and accumulated current support to the
> > > > OLPC battery driver.
> > > 
> > > How PROP_ACCUM_CURRENT is different from PROP_CHARGE_NOW (uAh)?
> > > 
> > > The DS2760 is already using the later to report its ACR
> > > register...
> > > 
> > 
> > Hm, I can change that.  In the meantime, I've stripped out the
> > ACR stuff.  Can you please use the following patch instead?  The
> > change doesn't conflict with the other 3 patches.
> 
> Thanks, applied to battery-2.6.git. Please see if everything is okay.
> 

Thanks!


> Do you want to see these patches in 2.6.26? I think it's a bit late
> (-rc1 is already released), but I also believe these patches are quite
> useful for OLPC and actually they do not touch anything but single
> driver...
> 

While I certainly wouldn't complain if they found their way into 2.6.26,
it's not that urgent (after all, I've been sitting on them since Feb).
