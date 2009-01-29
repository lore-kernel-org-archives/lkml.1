Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbZA2Fkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbZA2Fkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 00:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZA2FkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 00:40:23 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:30473 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176AbZA2FkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 00:40:22 -0500
Date: Thu, 29 Jan 2009 14:36:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, rmk+lkml@arm.linux.org.uk,
       cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
       geert@linux-m68k.org, Roman Zippel <zippel@linux-m68k.org>,
       Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
       chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 7/10] Convert sh to use arch_getoffset() infrastructure.
Message-ID: <20090129053609.GD32243@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	john stultz <johnstul@us.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>, rmk+lkml@arm.linux.org.uk,
	cooloney@kernel.org, starvik@axis.com, takata@linux-m32r.org,
	geert@linux-m68k.org, Roman Zippel <zippel@linux-m68k.org>,
	Magnus Damm <magnus.damm@gmail.com>, wli@holomorphy.com,
	chris@zankel.net, Thomas Gleixner <tglx@linutronix.de>
References: <1233201926.6895.25.camel@localhost.localdomain> <1233201995.6895.27.camel@localhost.localdomain> <1233202037.6895.30.camel@localhost.localdomain> <1233202074.6895.33.camel@localhost.localdomain> <1233202104.6895.35.camel@localhost.localdomain> <1233202139.6895.38.camel@localhost.localdomain> <1233202175.6895.40.camel@localhost.localdomain> <1233202206.6895.43.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233202206.6895.43.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 08:10:06PM -0800, john stultz wrote:
> This patch converts sh to use GENERIC_TIME via the arch_getoffset()
> infrastructure 
> 
> I do not have cross compilers for these architectures, and in some cases
> the architectures can be compiles both with and without clocksources. So
> I've taken my best swing at converting this, but I'm not confident I got
> it right. Any assistance from arch maintainers or testers would be
> great.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
