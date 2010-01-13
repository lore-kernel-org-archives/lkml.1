Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738Ab0AMM0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0AMM0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 07:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834Ab0AMM0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 07:26:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750814Ab0AMM0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 07:26:14 -0500
Date: Wed, 13 Jan 2010 12:26:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       "Quadros Roger (Nokia-D/Helsinki)" <roger.quadros@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: Add 'start-up time' to fixed voltage
 regulators
Message-ID: <20100113122612.GC27473@rakim.wolfsonmicro.main>
References: <4B4DB562.2080601@nokia.com>
 <20100113120327.GB27473@rakim.wolfsonmicro.main>
 <4B4DB94E.8080602@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DB94E.8080602@nokia.com>
X-Cookie: Kiss me twice.  I'm schizophrenic.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 02:15:10PM +0200, Adrian Hunter wrote:
> Mark Brown wrote:

> >>#include <linux/gpio.h>
> >>+#include <linux/delay.h>

> >I think your MUA may have eaten the patch - it looks like the leading
> >spaces got stripped which is liable to confuse things.

> Are you sure?  Looks fines to me.

The above should be

  >  #include <linux/gpio.h>
  > +#include <linux/delay.h>

IIRC ie, a one character indent on the context as well as the changed
lines.

> >startup_delay?  Just in case we think of another delay, though I'm
> >struggling to think of one right now so I'm not too worried.

> I am too lazy to change it unless there is something else too ;-)

On the other hand the cross tree issues will be annoying if it's changed
later...
