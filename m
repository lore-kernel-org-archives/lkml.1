Return-Path: <linux-kernel-owner+w=401wt.eu-S1752346AbZHEV3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbZHEV3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZHEV3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:29:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54783 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbZHEV3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:29:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>, pHilipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] PM: Add convenience macro to make switching to dev_pm_ops less error-prone
Date: Wed, 5 Aug 2009 23:30:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: albin.tonnerre@free-electrons.com, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       daniel@caiaq.de
References: <20090803163304.GF5002@laptop> <200908052205.14222.rjw@sisk.pl> <200908052222.31707.elendil@planet.nl>
In-Reply-To: <200908052222.31707.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052330.08452.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Frans Pop wrote:
> Rafael J. Wysocki wrote:
> 
> > +#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> > +struct dev_pm_ops name = { \
> > +       .suspend = suspend_fn, \
> > +       .resume = resume_fn, \
> > +       .freeze = suspend_fn, \
> > +       .thaw = resume_fn, \
> > +       .poweroff = suspend_fn, \
> > +       .resume = resume_fn, \
> 
> That defines .resume twice. Guess the last should be restore.

Yes, thanks to you and Philipp for noticing that and sorry for the mistake.

Rafael
