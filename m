Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYGJLGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYGJLGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYGJLGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:06:38 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:28731 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYGJLGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:06:37 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-3.tower-51.messagelabs.com!1215687996!5547302!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Thu, 10 Jul 2008 13:06:31 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] uio: uio_pdrv_genirq V2
Message-ID: <20080710110631.GA582@digi.com>
References: <20080710035254.27378.18682.sendpatchset@rx1.opensource.se> <20080710065639.GA16794@digi.com> <20080710105850.GA3202@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080710105850.GA3202@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 10 Jul 2008 11:06:33.0489 (UTC) FILETIME=[03572010:01C8E27D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Hans J. Koch wrote:
> > > +       ret = uio_register_device(&pdev->dev, priv->uioinfo);
> > > +       if (ret) {
> > > +               dev_err(&pdev->dev, "unable to register uio device\n");
> > > +               goto bad1;
> > > +       }
> > > +
> > > +       platform_set_drvdata(pdev, priv);
> > This should probably go before uio_register_device.  (Uups, this is an
> > issue for uio_pdrv, too.)
> 
> Yes, because uio_register_device will enable the irq, and you might
> arrive in the handler without having your platform data in place.
How do we want to fix that?  Should I sent a new version that also
includes the memory-leak fix and copyright specification?  Or another
incremental patch?

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
