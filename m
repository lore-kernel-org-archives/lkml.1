Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYGaAJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYGaAJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760406AbYGaAIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:08:48 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:51218 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676AbYGaAIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:08:46 -0400
X-BigFish: VPS-17(z1857rz1432R98dR1805M936fQ873fnzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4891032D.9070702@am.sony.com>
Date: Wed, 30 Jul 2008 17:11:25 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
 - build breakage
References: <20080723171841.815234000@polaris-admin.engr.sgi.com>	<20080723171841.997896000@polaris-admin.engr.sgi.com>	<4890C8E4.50503@am.sony.com>	<4890DC09.2020700@sgi.com>	<4890E539.6060905@am.sony.com> <20080731094816.3b5a53f4.sfr@canb.auug.org.au>
In-Reply-To: <20080731094816.3b5a53f4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2008 00:08:33.0272 (UTC) FILETIME=[91F8D780:01C8F2A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Tim,
> 
> On Wed, 30 Jul 2008 15:03:37 -0700 Tim Bird <tim.bird@am.sony.com> wrote:
>> I don't see 1eddd657 anywhere in the commit log for cpumask.h
>> Is it in linux-next?
> 
> Yeah, that was the commit from next-20080730.  (one less patch I need to
> apply :-))

FWIW, the patch fixed the problem for me.  With the latest linux-2.6
from Linus' tree, I compiled successfully for ARM OMAP.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

