Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142Ab0ASLMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0ASLMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173Ab0ASLMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:12:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:9642 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab0ASLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TsnGQeUUCo8njOf3qMpo6G3gzFvEHKv+AO4D0CUm+YqAtTDNA5lHIJSEgAd/oB0tqI
         1Kzu+4DoXbUGuPFh5wsBMJ8Cl0qBOhqiZ9zV4pDGhwoScO7IsKBMcWULjAB9//oISzeH
         4fvIN0kQFqYgYiQz2d1tBgYYs0RvmdHckx8OA=
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1263896816.3089.40.camel@odin>
References: <1263830523.3632.22.camel@realization>
	 <20100118190445.GA16989@pengutronix.de>
	 <1263848512.3632.74.camel@realization>  <1263896816.3089.40.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 12:12:30 +0100
Message-ID: <1263899550.6669.21.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mar, 2010-01-19 at 10:26 +0000, Liam Girdwood wrote:
> > +static struct regulator_ops mc13783_gpo_regulator_ops = {
> > +     .enable = mc13783_gpo_regulator_enable,
> > +     .disable = mc13783_gpo_regulator_disable,
> > +     .is_enabled = mc13783_gpo_regulator_is_enabled,
> 
> How is the voltage output on the GPO regulator governed. Is it
> controlled by a parent regulator or fixed ?
> 
> We probably want a way to query the voltage here or specify the parent
> relationship. 

Good question.
>From datasheet GPO's are marked as LV (Low Voltage)-> 3.1V
Power Gates Driver are marked as EMV (Extended Medium Voltage) -> 5.5V

and no way to modify that -> they are fixed regulators.

I will add voltage query capability.

