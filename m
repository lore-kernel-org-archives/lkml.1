Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZHFIvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZHFIvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZHFIvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:51:48 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:37477 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZHFIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:51:47 -0400
Date: Thu, 6 Aug 2009 10:51:44 +0200
From: Daniel Mack <daniel@caiaq.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, pHilipp Zabel <philipp.zabel@gmail.com>,
       albin.tonnerre@free-electrons.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] PM: Add convenience macro to make switching to
	dev_pm_ops less error-prone
Message-ID: <20090806085144.GS13236@buzzloop.caiaq.de>
References: <20090803163304.GF5002@laptop> <200908052205.14222.rjw@sisk.pl> <200908052222.31707.elendil@planet.nl> <200908052330.08452.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908052330.08452.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 11:30:07PM +0200, Rafael J. Wysocki wrote:
> On Wednesday 05 August 2009, Frans Pop wrote:
> > Rafael J. Wysocki wrote:
> > 
> > > +#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> > > +struct dev_pm_ops name = { \
> > > +       .suspend = suspend_fn, \
> > > +       .resume = resume_fn, \
> > > +       .freeze = suspend_fn, \
> > > +       .thaw = resume_fn, \
> > > +       .poweroff = suspend_fn, \
> > > +       .resume = resume_fn, \
> > 
> > That defines .resume twice. Guess the last should be restore.
> 
> Yes, thanks to you and Philipp for noticing that and sorry for the mistake.

When is a good point to resend patches that use this macro? I guess they
won't make it to .31 anyway, right? So I just wait for the next merge
window?

Daniel

