Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYIQTaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYIQTaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYIQTaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:30:22 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:57853 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbYIQTaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:30:21 -0400
Date: Wed, 17 Sep 2008 21:30:13 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Bryan Wu <cooloney@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] gpio_free might sleep, blackfin architecture
Message-ID: <20080917193012.GA27410@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Bryan Wu <cooloney@kernel.org>, linux-kernel@vger.kernel.org,
	David Brownell <david-b@pacbell.net>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de> <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de> <386072610809151916j7ed1ad54i330a7ee0be692828@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <386072610809151916j7ed1ad54i330a7ee0be692828@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bryan,

Bryan Wu wrote:
> On Tue, Sep 16, 2008 at 4:02 AM, Uwe Kleine-König
> <ukleinek@informatik.uni-freiburg.de> wrote:
> > According to the documentation gpio_free should only be called from task
> > context only.  To make this more explicit add a might sleep to all
> > implementations.
> >
> > This patch changes the gpio_free implementations for the blackfin
> > architecture.
> >
> 
> It looks fine for me, thanks a lot.
> 
> Acked-by: Bryan Wu <cooloney@kernel.org>
I suspect David suggested to split my initial patch at arch lines
because then the patches can go via the arch trees into vanilla.

Best regards and thanks,
Uwe

-- 
Uwe Kleine-König

http://www.google.com/search?q=0+degree+Celsius+in+kelvin
