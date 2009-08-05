Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZHESqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZHESqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZHESqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:46:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbZHESqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:46:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH] Add SIMPLE_PM_OPS: make switching to dev_pm_ops less error-prone
Date: Wed, 5 Aug 2009 20:47:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc5-rjw; KDE/4.2.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linux PM List <linux-pm@lists.linux-foundation.org>
References: <20090803163304.GF5002@laptop> <20090805045533.C3574526EA5@mailhub.coreip.homeip.net> <20090805093758.GE5854@laptop>
In-Reply-To: <20090805093758.GE5854@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052047.26293.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Albin Tonnerre wrote:
> On Tue, Aug 04, 2009 at 09:55:33PM -0700, Dmitry Torokhov wrote :
> > On Tue, Aug 04, 2009 at 11:36:12AM +0200, Albin Tonnerre wrote:
> > > In a number of cases, the .suspend, .freeze, .poweroff and .resume,
> > > .thaw, .restore functions are identical. However, they all need to be
> > > assigned to avoid regressionsm as the previous code called .suspend
> > > resp. .resume in all those cases. SIMPLE_PM_OPS allows to deal with
> > > this case.
> 
> 
> > I'd much rather have conversions done with a bit more analysis now that
> > our framework is more flexible and we can have specialized routines for
> > hibernation and suspend.
> 
> I still think that even though they can, quite a number of drivers won't
> /need/ to have different functions for this, but maybe I'm mistaken.
> 
> > Maybe we should try changing from run-time to build time warning so that
> > users are not overly concerned with it?
> 
> I'm not sure that solves the problem. The fact is that even for developers, it's
> easy to overlook that assiging only the .suspend and .resume fields is probably
> a mistake.

I agree, so I'm going to take the patch.

I'll add a comment describing what the macro is for, though.

Thanks,
Rafael
