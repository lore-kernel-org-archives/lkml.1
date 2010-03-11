Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab0CKPkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:40:21 -0500
Received: from ns.penguin.cz ([84.21.108.25]:49491 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab0CKPkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:40:19 -0500
Subject: Re: bit errors on spitz
From: Stanislav Brabec <utx@penguin.cz>
To: Andy Green <andy@warmcat.com>
Cc: Cyril Hrubis <metan@ucw.cz>, Pavel Machek <pavel@ucw.cz>,
       Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       arminlitzel@web.de, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       omegamoon@gmail.com, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4B98EF5D.5000609@warmcat.com>
References: <20100305212708.GC21773@elf.ucw.cz>
	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>
	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>
	 <4B98EF5D.5000609@warmcat.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Thu, 11 Mar 2010 16:42:35 +0100
Message-ID: <1268322155.3990.114.camel@hammer.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Green wrote:

> I saw very similar failures for a long time on our iMX31 based device. 
> Eventually I found a Freescale errata where the RAM inside the USB2 
> macrocell started to make single bit errors below 1.38V Vcore; ours was 
> 1.4V at that time but dipped on CPU load.

Good tip. It seems that nobody ported driver for the voltage control
chip ISL6271 from 2.4 kernel, and bootloader probably does not set
correct values.

Datasheet:
http://www.penguin.cz/~utx/zaurus/datasheets/power/Xscale/ISL6271.pdf

-- 
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

