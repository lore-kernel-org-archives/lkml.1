Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYLJEWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYLJEWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 23:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLJEWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 23:22:40 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:10535 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751820AbYLJEWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 23:22:39 -0500
Date: Wed, 10 Dec 2008 13:19:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, rmk+lkml@arm.linux.org.uk,
       cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
       geert@linux-m68k.org, Roman Zippel <zippel@linux-m68k.org>,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/3] Convert !GENERIC_TIME arches to use arch_getoffset() infrastructure.
Message-ID: <20081210041943.GA27356@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	john stultz <johnstul@us.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>, rmk+lkml@arm.linux.org.uk,
	cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
	geert@linux-m68k.org, Roman Zippel <zippel@linux-m68k.org>,
	Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
	chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
References: <1228794561.6918.57.camel@localhost.localdomain> <1228794627.6918.59.camel@localhost.localdomain> <1228794667.6918.61.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228794667.6918.61.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 07:51:07PM -0800, john stultz wrote:
> This converts the following arches to use the arch_getoffset()
> infrastructure, finally bringing them into the GENERIC_TIME fold:
> 
> arm
> blackfin
> cris
> m32r
> m68k
> sh
> sparc
> xtensa
> 
> I have split out patches for each arch, but I'm sending out the
> megapatch to keep the RFC patchlist short.
> 
> I do not have cross compilers for these architectures, and in some cases
> (like arm, and sh) the architectures can be compiles both with and
> without clocksources. So I've taken my best swing at converting this,
> but I'm not confident I got it right. Any assistance from arch
> maintainers or testers would be great.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
Just got around to testing the SH bits, works fine in both
configurations.

Acked-by: Paul Mundt <lethal@linux-sh.org>
