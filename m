Return-Path: <linux-kernel-owner+w=401wt.eu-S932243AbZGOTHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbZGOTHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZGOTHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:07:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932224AbZGOTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:07:11 -0400
Date: Wed, 15 Jul 2009 12:06:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: mreimer@vpop.net, linux-kernel@vger.kernel.org, szabolcs.gyurko@tlt.hu,
       cbou@mail.ru
Subject: Re: [PATCH 4/4] ds2760: handle full_active_uAh == 0 case correctly
Message-Id: <20090715120625.cb8937f3.akpm@linux-foundation.org>
In-Reply-To: <20090715185159.GI9464@buzzloop.caiaq.de>
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
	<1247674841-9909-2-git-send-email-daniel@caiaq.de>
	<1247674841-9909-3-git-send-email-daniel@caiaq.de>
	<1247674841-9909-4-git-send-email-daniel@caiaq.de>
	<147B4C9E-4AE2-4FAD-BC58-7D5D905A1B77@vpop.net>
	<20090715185159.GI9464@buzzloop.caiaq.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 20:51:59 +0200
Daniel Mack <daniel@caiaq.de> wrote:

> On Wed, Jul 15, 2009 at 11:06:29AM -0700, Matt Reimer wrote:
> > On Jul 15, 2009, at 9:20 AM, Daniel Mack wrote:
> >
> >> In systems where the battery monitor is not part of the battery pack  
> >> and
> >> is hence not bootstrapped with sane values, the full_active_uAh is
> >> likely to be zero.
> >>
> >> Handle that case by defaulting to the rated_capacity information which
> >> can be passed to the driver using the new module parameter.
> >>
> >> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> >> Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
> >> Cc: Matt Reimer <mreimer@vpop.net>
> >> Cc: Anton Vorontsov <cbou@mail.ru>
> >
> > Acked-by: Matt Reimer <mreimer@vpop.net>
> 
> Thanks Matt :) Andrew, will they go thru your channel?
> 

Well.  I'll look at them, as I try to do when someone cc'ed me.  But
drivers/power is usually handled by Anton?

