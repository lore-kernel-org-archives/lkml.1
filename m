Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZFOLeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZFOLeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZFOLd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:33:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:32909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZFOLd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:33:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="466411892"
Date: Mon, 15 Jun 2009 19:29:19 +0800
From: Alek Du <alek.du@intel.com>
To: Ben Dooks <ben-linux@fluff.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
 gpio_alt_func features to GPIOLIB
Message-ID: <20090615192919.2cc506a0@dxy.sh.intel.com>
In-Reply-To: <20090615095023.GA19873@fluff.org.uk>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
	<20090615095023.GA19873@fluff.org.uk>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 17:50:23 +0800
Ben Dooks <ben-linux@fluff.org> wrote:

> > +enum gpio_trigger_t {
> > +	DETECT_LEVEL_LOW = -2,
> > +	DETECT_EDGE_FALLING = -1,
> > +	DETECT_DISABLE = 0,
> > +	DETECT_EDGE_RISING = 1,
> > +	DETECT_LEVEL_HIGH = 2,
> > +	DETECT_EDGE_BOTH = 3,
> > +};
> 
> wny not reuse the IRQ trigger types?
> 

Don't know it this is a good reason: the IRQ trigger name IRQ_TYPE_*
seems not good as DETECT_*. Since not all GPIO device would have IRQ line
connected to interrupt controller -- some of them just set a trigger bit
when detection happens.

Thanks,
Alek
