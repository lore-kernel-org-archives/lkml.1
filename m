Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZHFMQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZHFMQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZHFMQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:16:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbZHFMQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:16:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] PM: Add convenience macro to make switching to dev_pm_ops less error-prone
Date: Thu, 6 Aug 2009 14:16:08 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, pHilipp Zabel <philipp.zabel@gmail.com>,
       albin.tonnerre@free-electrons.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20090803163304.GF5002@laptop> <200908052330.08452.rjw@sisk.pl> <20090806085144.GS13236@buzzloop.caiaq.de>
In-Reply-To: <20090806085144.GS13236@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908061416.08564.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009, Daniel Mack wrote:
> On Wed, Aug 05, 2009 at 11:30:07PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday 05 August 2009, Frans Pop wrote:
> > > Rafael J. Wysocki wrote:
> > > 
> > > > +#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> > > > +struct dev_pm_ops name = { \
> > > > +       .suspend = suspend_fn, \
> > > > +       .resume = resume_fn, \
> > > > +       .freeze = suspend_fn, \
> > > > +       .thaw = resume_fn, \
> > > > +       .poweroff = suspend_fn, \
> > > > +       .resume = resume_fn, \
> > > 
> > > That defines .resume twice. Guess the last should be restore.
> > 
> > Yes, thanks to you and Philipp for noticing that and sorry for the mistake.
> 
> When is a good point to resend patches that use this macro? I guess they
> won't make it to .31 anyway, right? So I just wait for the next merge
> window?

Yes, I think that would be the right thing to do.

Best,
Rafael
