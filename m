Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYKNAVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYKNAVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYKNAVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:21:00 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51577 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753896AbYKNAU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:20:59 -0500
Message-ID: <491CC469.20508@sgi.com>
Date: Thu, 13 Nov 2008 16:20:57 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org>	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	<20081110094033.GL22392@elte.hu>	<20081110015511.453a801e.akpm@linux-foundation.org>	<4918065A.6050402@kernel.org>	<20081110100329.GA19970@elte.hu>	<491A9F87.8040403@kernel.org>	<20081112120814.GG11352@elte.hu>	<491C8B38.9060901@kernel.org>	<20081113131850.d94fb229.akpm@linux-foundation.org>	<86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>	<20081113141340.7e17bdca.akpm@linux-foundation.org>	<491CAD20.9020202@kernel.org> <20081113145846.bef2bb90.akpm@linux-foundation.org> <491CB500.8090203@sgi.com> <491CB73E.3030202@kernel.org>
In-Reply-To: <491CB73E.3030202@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Mike Travis wrote:
>> Andrew Morton wrote:
>>> On Thu, 13 Nov 2008 14:41:36 -0800
>>> Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>> That's a good question.  If there are 4k or 16k cpus, would the number of
>> irq's being "kstat'd" need to be > 64k?  (I'm not exactly sure why there
>> are NR_CPUS * NR_IRQS_LEGACY kstat entries per IRQ?)
> 
> can be replaced with nr_cpu_ids * NR_IRQS_LEGACY...
> 
> YH

Ok, but why does each irq need a list of all other irq's in the system?
Can they be collapsed into one array or percpu list?

Thanks,
Mike 
