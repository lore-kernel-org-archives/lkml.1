Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZEPBXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZEPBXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZEPBXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:23:25 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59268 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZEPBXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:23:25 -0400
Subject: Re: [PATCH 23/30] loongson: CS5536 MFGPT as system clock source
 support
From: John Stultz <johnstul@us.ibm.com>
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, zhangfx@lemote.com, yanh@lemote.com,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Erwan Lerale <erwan@thiscow.com>
In-Reply-To: <1242436541.10164.194.camel@falcon>
References: <1242426182.10164.168.camel@falcon>
	 <1f1b08da0905151739v6bc2e5f6t57cb8e06cdda2673@mail.gmail.com>
	 <1242436541.10164.194.camel@falcon>
Content-Type: text/plain
Date: Fri, 15 May 2009 18:23:24 -0700
Message-Id: <1242437004.29511.202.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-16 at 09:15 +0800, Wu Zhangjin wrote:
> On Fri, 2009-05-15 at 17:39 -0700, john stultz wrote:
> > On Fri, May 15, 2009 at 3:23 PM, Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> > > +static struct clocksource clocksource_mfgpt = {
> > > +    .name = "mfgpt",
> > > +    .rating = 1200,
> > 
> > Minor nit. Please read the comment over the struct clocksource
> > definition in include/linux/clocksource.h for a guide to setting the
> > rating value for your clocksource.
> > 
> 
> as the comment describes, just like the 8253 Timer, the precision of
> cs5536 mfgpt Timer is not good, the rating of it should be in the range
> of 100-199? Functional for real use, but not desired?

That would seem reasonable to me, as it insures that should better
clocksources become available on the hardware, it will pick the better
hardware.

But I'll leave the final call to you.

I just wanted to make sure we're all using the same scale, and 1200 was
off the charts ;)

thanks
-john

