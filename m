Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXCTJRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXCTJRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbXCTJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:17:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40210 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbXCTJRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:17:30 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Arjan van de Ven <arjan@infradead.org>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: Lee Revell <rlrevell@joe-job.com>, tglx@linutronix.de,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Len Brown <lenb@kernel.org>
In-Reply-To: <1174368995.14239.3.camel@perkele>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <75b66ecd0703192204n503eb4d3g361064f66319dd4c@mail.gmail.com>
	 <1174368995.14239.3.camel@perkele>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 20 Mar 2007 10:15:41 +0100
Message-Id: <1174382141.1158.61.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 01:36 -0400, Eric St-Laurent wrote:
> On Tue, 2007-20-03 at 01:04 -0400, Lee Revell wrote:
> 
> > I think CONFIG_TRY_TO_DISABLE_SMI would be excellent for debugging,
> > not to mention people trying to spec out hardware for RT
> > applications...
> 
> There is a SMI disabling module in RTAI, check the smi-module.c in this:
> 
> https://www.rtai.org/RTAI/rtai-3.5.tar.bz2
> 
> More infos:
> 
> http://www.captain.at/rtai-smi-high-latency.php
> http://www.captain.at/xenomai-smi-high-latency.php
> 
> It might make sense to merge this code, at least in the -rt tree.

it NEVER makes sense to disable SMM.

SMM is there to ensure that your hardware doesn't get physically
damaged.

disabling that is a BAD idea. I'm no fan of SMM myself, but it's there,
and we have to live with it. Disabling it without knowing what it does
on your system is madness.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

