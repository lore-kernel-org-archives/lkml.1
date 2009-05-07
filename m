Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbZEGMKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbZEGMKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761277AbZEGMKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:10:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35979 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761156AbZEGMKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:10:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [RFC][PATCH 1/5] PM/Freezer: Disable OOM killer when tasks are frozen
Date: Thu, 7 May 2009 14:10:37 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200905070040.08561.rjw@sisk.pl> <200905070041.04787.rjw@sisk.pl> <1241650843.19600.124.camel@nigel-laptop>
In-Reply-To: <1241650843.19600.124.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071410.37812.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Nigel Cunningham wrote:
> Hi.

Hi,

> On Thu, 2009-05-07 at 00:41 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The OOM killer is not really going to work while tasks are frozen, so
> > we can just give up calling it in that case.
> > 
> > This will allow us to safely use memory allocations for decreasing
> > the number of saveable pages in the hibernation core code instead of
> > using any artificial memory shriking mechanisms for this purpose.
> 
> Should we disable the warning that the nopage path gives if tasks are
> frozen? I'm in two minds - if you get problems as a result, it might
> help to diagnose them. On the other hand, you don't want tons of
> warnings due to the hibernation code trying to allocate memory it can't
> get. In TuxOnIce, I currently do all allocations with __GFP_NOWARN.

Yes, I use __GFP_NOWARN in the next patches too. :-)

Thanks,
Rafael
