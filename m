Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694Ab0AZK3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0AZK3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418Ab0AZK3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:29:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55268 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0AZK3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:29:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gel4z1h04+IuBvoiduEdnJZyKhz36ufQ2SAaneMLVoEppxmJseSjijZ+G6/ue6TN0k
         JM/3m+0fhGmpKiKLSY3Ykv8mNMKQRFWam56BJyBcVjmdn8+eWLFxL25IQjXr3SBEb99S
         KjOssTGWvubrCSW38srEoOKVTlj91l8sx8joc=
Subject: Re: [PATCH v2] input: MXC: add mxc-keypad driver to support the
 Keypad Port present in the mxc application processors family.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-input@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <20100126095217.GC3480@core.coreip.homeip.net>
References: <1262977099.2050.75.camel@climbing-alby>
	 <BD79186B4FD85F4B8E60E381CAEE190902089738@mi8nycmail19.Mi8.com>
	 <1263664125.4350.18.camel@realization>
	 <20100126095217.GC3480@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 11:29:01 +0100
Message-ID: <1264501741.5260.29.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry! Thanks for reviewing!

On mar, 2010-01-26 at 01:52 -0800, Dmitry Torokhov wrote:
> > This algorithm is done via a threaded management of the keypad interrupt source
> > and delayed by a proper (and longer) debounce interval controlled by the 
> > platform initialization.
> 
> This I am not so sure about - the core of the matrix scan routine does
> not sleep so I wonder if starting a separate thread is not too wasteful
> in this case - you can easily do whan you want with a timer, no?

I'm pretty new to kernel programming and, from the university, the 
threaded way looked the better (and unique) for me..
Let me find some documentation on timers and I will restructure the 
interrupt management. Yes I need only to delay the matrix-scan activity
without waste cpu time.

> 
> > +
> > +     /*
> > +      * Search for rows and cols enabled
> > +      */
> > +     keymap_data = (struct matrix_keymap_data *) pdata->keymap_data;
> 
> Why do you need to cast away constness instead of declaring keymap_data
> as const pointer?

In next version will be fixed.

Alberto!


