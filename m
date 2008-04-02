Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYDBPis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYDBPis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbYDBPik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:38:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37752 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbYDBPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:38:39 -0400
Subject: Re: [PATCH 1/2] Keep track of original clocksource frequency
From: John Stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804021314400.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>
	 <Pine.LNX.4.64.0804021314400.26791@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 08:38:37 -0700
Message-Id: <1207150717.6211.0.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 13:20 +0200, Roman Zippel wrote:
> Hi,
> 
> On Tue, 18 Mar 2008, john stultz wrote:
> 
> > @@ -63,6 +64,7 @@ struct clocksource {
> >  	cycle_t (*read)(void);
> >  	cycle_t mask;
> >  	u32 mult;
> > +	s32 mult_orig;
> >  	u32 shift;
> >  	unsigned long flags;
> >  	cycle_t (*vread)(void);
> 
> This is wrong, with HZ=100 the jiffies clock multiplier suddenly becomes 
> negative and later the raw interval underflows.

Ah, thanks for catching that!

> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

Acked-by: John Stultz <johnstul@us.ibm.com>



