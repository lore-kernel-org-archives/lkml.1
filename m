Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbYB1HUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbYB1HUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYB1HUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:20:31 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYB1HUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:20:30 -0500
Date: Wed, 27 Feb 2008 23:09:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Graeme Gregory <gg@opensource.wolfsonmicro.com>,
       Mike Arthur <mike.arthur@wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stanley Cai <stanley.cai@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Marc Kleine-Budde <mkl@pengutronix.de>,
       Pete MacKay <linux01@architechnical.net>, Ian Molton <spyro@f2s.com>,
       Vince Sanders <vince@kyllikki.org>, Andrew Zabolotny <zap@homelink.ru>
Subject: Re: [PATCH 3/6] Add chip driver for WM9712 touchscreen
Message-Id: <20080227230937.e3e0fb41.akpm@linux-foundation.org>
In-Reply-To: <12040332181394-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <12040332183316-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332181161-git-send-email-broonie@opensource.wolfsonmicro.com>
	<12040332181394-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 13:40:15 +0000 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> +/*
> + * Set adc sample delay.
> + *
> + * For accurate touchpanel measurements, some settling time may be
> + * required between the switch matrix applying a voltage across the
> + * touchpanel plate and the ADC sampling the signal.
> + *
> + * This delay can be set by setting delay = n, where n is the array
> + * position of the delay in the array delay_table below.
> + * Long delays > 1ms are supported for completeness, but are not
> + * recommended.
> + */
> +static int delay = 3;
> +module_param(delay, int, 0);
> +MODULE_PARM_DESC(delay, "Set adc sample delay.");

I assume we don't support more than one attached device per host?

If so, is that a problem?  One could envisage an application with lots
of screens attached to one Linux box.
