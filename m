Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZGWIje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZGWIje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZGWIje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:39:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33800 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752493AbZGWIjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:39:33 -0400
Date: Thu, 23 Jul 2009 09:39:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] regulator: Warn when unregistering an in-use
 regulator
Message-ID: <20090723083931.GA5744@rakim.wolfsonmicro.main>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248293694.25964.817.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248293694.25964.817.camel@vega.slimlogic.co.uk>
X-Cookie: <wiggy> bwah, vodka in my mouse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 09:14:54PM +0100, Liam Girdwood wrote:
> On Tue, 2009-07-21 at 16:00 +0100, Mark Brown wrote:

> >  	mutex_lock(&regulator_list_mutex);
> > +	WARN_ON(rdev->open_count)

> Missing ;  Fixed.

Thanks.  The scary thing is that it compiles for me.

> 
> >  	unset_regulator_supplies(rdev);
> >  	list_del(&rdev->list);
> >  	if (rdev->supply)
> 
> Applied.
> 
> Thanks
> 
> Liam
> 
