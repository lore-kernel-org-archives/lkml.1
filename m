Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab0CAL5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:57:01 -0500
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:18099 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751192Ab0CAL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:57:00 -0500
X-Greylist: delayed 2054 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 06:56:54 EST
From: Ian Campbell <ijc@hellion.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <4B881097.1050505@kernel.org>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	 <tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	 <4B881097.1050505@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 11:22:25 +0000
Message-ID: <1267442545.11737.20718.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add
 arch_probe_nr_irqs() again
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=xE1qpWtd3IAA:10 a=zTfOVrVR-XCbWqQERIkA:9 a=e74zu2V4jDPjODFp6G-N2sa1ougA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 10:19 -0800, Yinghai Lu wrote:
> 
> 
> for x86, with radix tree based irq_to_desc(),
> removing arch_probe_nr_irqs is intentional. so we get more irq that
> could be used. 

This sounds interesting for the Xen dom0 use case where we can have
essentially arbitrary numbers of interrupt sources.

Is there a tree somewhere that I can be looking at?

Ian
-- 
Ian Campbell
Current Noise: Rammstein - Morgenstern

Money will say more in one moment than the most eloquent lover can in years.

