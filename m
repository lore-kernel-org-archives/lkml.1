Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbZAHKPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbZAHKPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZAHKP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:15:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759088AbZAHKPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:15:23 -0500
Date: Thu, 8 Jan 2009 11:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: wimax@linuxwimax.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: Re: linux-next: Tree for January 7 (wimax: more)
Message-ID: <20090108101501.GA15294@elte.hu>
References: <20090107170646.8d44292b.sfr@canb.auug.org.au> <4964EDE6.5090902@oracle.com> <200901071051.23010.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901071051.23010.inaky@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Inaky Perez-Gonzalez <inaky@linux.intel.com> wrote:

> On Wednesday 07 January 2009, Randy Dunlap wrote:
> > Stephen Rothwell wrote:
> > > Hi all,
> > >
> > > The powerpc ppc44x_defconfig builds again.
> > >
> > > Changes since 20090106:
> >
> > drivers/net/wimax/i2400m/usb.c:403: error: 'struct usb_device' has no
> > member named 'autosuspend_delay' drivers/net/wimax/i2400m/usb.c:404: error:
> > 'struct usb_device' has no member named 'autosuspend_disabled'
> > drivers/net/wimax/i2400m/usb.c:506: error: 'struct usb_device' has no
> > member named 'auto_pm'
> 
> Fix on the way -- need #ifdef CONFIG_PMs in a few parts.

FYI, this build bug has now hit upstream too:

drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_probe':
drivers/net/wimax/i2400m/usb.c:403: error: 'struct usb_device' has no member named 'autosuspend_delay'
drivers/net/wimax/i2400m/usb.c:404: error: 'struct usb_device' has no member named 'autosuspend_disabled'
drivers/net/wimax/i2400m/usb.c: In function 'i2400mu_suspend':
drivers/net/wimax/i2400m/usb.c:506: error: 'struct usb_device' has no member named 'auto_pm'

	Ingo
