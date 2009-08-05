Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZHESpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZHESpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZHESpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:45:04 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56719 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZHESpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:45:02 -0400
Date: Wed, 5 Aug 2009 20:45:00 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Ville Syrjala <syrjala@sci.fi>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/5] w1_gpio: switch to new dev_pm_ops
Message-ID: <20090805184500.GO13236@buzzloop.caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de> <200908052044.02103.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908052044.02103.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 08:44:01PM +0200, Rafael J. Wysocki wrote:
> > +static struct dev_pm_ops w1_gpio_pm_ops = {
> > +	.suspend	= w1_gpio_suspend,
> > +	.freeze		= w1_gpio_suspend,
> > +	.resume		= w1_gpio_resume,
> > +	.thaw		= w1_gpio_resume,
> 
> You need
> 
> +	.poweroff	= w1_gpio_suspend,
> +	.restore		= w1_gpio_resume,
> 
> in addition to these, which seems to be the case with the rest of the patches
> too.
> 
> If you wait for a little while with the patchset, we're going to have a
> convenience macro for defining such 'standard' dev_pm_ops objects.

Ok, fine. Letting them all point the same function looks somwhat hackish
to me, so I'll wait for that macro. Let me know when that has arrived :)

Daniel
