Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbYGJNvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbYGJNvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYGJNvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:51:15 -0400
Received: from www.tglx.de ([62.245.132.106]:51719 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYGJNvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:51:14 -0400
Date: Thu, 10 Jul 2008 15:49:46 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710134946.GC3202@local>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se> <20080710065639.GA16794@digi.com> <20080710105850.GA3202@local> <20080710110631.GA582@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080710110631.GA582@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:06:31PM +0200, Uwe Kleine-König wrote:
> Hi,
> 
> Hans J. Koch wrote:
> > > > +       ret = uio_register_device(&pdev->dev, priv->uioinfo);
> > > > +       if (ret) {
> > > > +               dev_err(&pdev->dev, "unable to register uio device\n");
> > > > +               goto bad1;
> > > > +       }
> > > > +
> > > > +       platform_set_drvdata(pdev, priv);
> > > This should probably go before uio_register_device.  (Uups, this is an
> > > issue for uio_pdrv, too.)
> > 
> > Yes, because uio_register_device will enable the irq, and you might
> > arrive in the handler without having your platform data in place.
> How do we want to fix that?  Should I sent a new version that also
> includes the memory-leak fix and copyright specification?  Or another
> incremental patch?

Send another incremental patch for uio_pdrv, just for the records.
I'll sort it out with Greg later, if he finds many small patches
annoying, I can easily combine them.

Thanks,
Hans

