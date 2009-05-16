Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZEPBQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZEPBQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZEPBPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:15:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:63596 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZEPBPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=wTJd861BVXwqf0wl9DT5VreohgHHqxAe/FPuc7QvMh+ooIJrX/tzJW61u4WrhrtD62
         fFF9qIgRnJEDZVmip1hfhtkfM9mafEEvAipul+lM++K2vzwkNrjuh34/d5V0xO3xhmBf
         PLvfYOnEsRCTF0yshhMmxCMRfJYqaoeIVkb9c=
Subject: Re: [PATCH 23/30] loongson: CS5536 MFGPT as system clock source 
 support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: john stultz <johnstul@us.ibm.com>
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       linux-kernel@vger.kernel.org, Arnaud Patard <apatard@mandriva.com>,
       loongson-dev@googlegroups.com, zhangfx@lemote.com, yanh@lemote.com,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Erwan Lerale <erwan@thiscow.com>
In-Reply-To: <1f1b08da0905151739v6bc2e5f6t57cb8e06cdda2673@mail.gmail.com>
References: <1242426182.10164.168.camel@falcon>
	 <1f1b08da0905151739v6bc2e5f6t57cb8e06cdda2673@mail.gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sat, 16 May 2009 09:15:41 +0800
Message-Id: <1242436541.10164.194.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 17:39 -0700, john stultz wrote:
> On Fri, May 15, 2009 at 3:23 PM, Wu Zhangjin <wuzhangjin@gmail.com> wrote:
> > +static struct clocksource clocksource_mfgpt = {
> > +    .name = "mfgpt",
> > +    .rating = 1200,
> 
> Minor nit. Please read the comment over the struct clocksource
> definition in include/linux/clocksource.h for a guide to setting the
> rating value for your clocksource.
> 

as the comment describes, just like the 8253 Timer, the precision of
cs5536 mfgpt Timer is not good, the rating of it should be in the range
of 100-199? Functional for real use, but not desired?

thanks!
Wu Zhangjin

