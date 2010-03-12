Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab0CLKmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:42:50 -0500
Received: from ns.penguin.cz ([84.21.108.25]:34328 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab0CLKms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:42:48 -0500
Subject: Re: bit errors on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Andy Green <andy@warmcat.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com
In-Reply-To: <4B9A0A71.7010206@warmcat.com>
References: <20100305212708.GC21773@elf.ucw.cz>
	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
	 <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>
	 <4B995EE1.1050609@warmcat.com> <1268384824.4963.35.camel@utx.utx.cz>
	 <4B9A0A71.7010206@warmcat.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Fri, 12 Mar 2010 11:43:08 +0100
Message-ID: <1268390588.4963.66.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Green wrote:

> In that case is the PXA CF driver PIO?  Then it can be the same load on 
> Vcore issue in disguise.

There is a proprietary ASIC chip (Sharp Scoop) that handles CF and HDD
access (and also several additional GPIOs):
http://www.penguin.cz/~utx/zaurus/datasheets/ASIC_S1L50752B26B200/412752.PDF

The ASIC runs in dual power mode. HVDD is powered from the 3.3V
dedicated to CF resp. HDD power supply (both may be turned off by the
kernel), LVDD is shared with CPU 3.3V (it is always on).

It seems that there are no other chips connected to the VCC_PLL,
VCC_SRAM and VCC_CORE.

VCC_DRAM is the same 3.3V ans CPU ans ASIC LVDD and also the same as
flash power and flash driver CPLD:
http://www.penguin.cz/~utx/zaurus/datasheets/memory/


________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

