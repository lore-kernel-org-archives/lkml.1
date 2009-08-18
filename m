Return-Path: <linux-kernel-owner+w=401wt.eu-S1759031AbZHRQMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031AbZHRQMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZHRQMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:12:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42850 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHRQMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:12:49 -0400
Message-ID: <4A8AD2E6.8090703@cs.helsinki.fi>
Date: Tue, 18 Aug 2009 19:12:22 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Amerigo Wang <amwang@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] proc: drop write permission on 'timer_list' and 'slabinfo'
References: <20090817094525.6355.88682.sendpatchset@localhost.localdomain>  <20090817094822.GA17838@elte.hu> <1250502847.5038.16.camel@penberg-laptop> <alpine.DEB.1.10.0908171228300.16267@gentwo.org> <4A8986BB.80409@cs.helsinki.fi> <alpine.DEB.1.10.0908171240370.16267@gentwo.org> <4A8A0B0D.6080400@redhat.com> <4A8A0B14.8040700@cn.fujitsu.com>
In-Reply-To: <4A8A0B14.8040700@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>>  static int __init slab_proc_init(void)
>>  {
>> -	proc_create("slabinfo",S_IWUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
>> +	proc_create("slabinfo",S_IRUSR|S_IRUGO,NULL,&proc_slabinfo_operations);
> 
> S_IRUSR|S_IRUGO == S_IRUGO
> 
>>  	return 0;
>>  }
>>  module_init(slab_proc_init);
> 

I went ahead and fixed that. Applied, thanks everyone!
