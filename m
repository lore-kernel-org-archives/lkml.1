Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbYKMXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbYKMXZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYKMXZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:25:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:37484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYKMXZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:25:09 -0500
Message-ID: <491CB73E.3030202@kernel.org>
Date: Thu, 13 Nov 2008 15:24:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org>	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	<20081110094033.GL22392@elte.hu>	<20081110015511.453a801e.akpm@linux-foundation.org>	<4918065A.6050402@kernel.org>	<20081110100329.GA19970@elte.hu>	<491A9F87.8040403@kernel.org>	<20081112120814.GG11352@elte.hu>	<491C8B38.9060901@kernel.org>	<20081113131850.d94fb229.akpm@linux-foundation.org>	<86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com>	<20081113141340.7e17bdca.akpm@linux-foundation.org>	<491CAD20.9020202@kernel.org> <20081113145846.bef2bb90.akpm@linux-foundation.org> <491CB500.8090203@sgi.com>
In-Reply-To: <491CB500.8090203@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Andrew Morton wrote:
>> On Thu, 13 Nov 2008 14:41:36 -0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
> 
> That's a good question.  If there are 4k or 16k cpus, would the number of
> irq's being "kstat'd" need to be > 64k?  (I'm not exactly sure why there
> are NR_CPUS * NR_IRQS_LEGACY kstat entries per IRQ?)

can be replaced with nr_cpu_ids * NR_IRQS_LEGACY...

YH
