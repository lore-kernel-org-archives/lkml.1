Return-Path: <linux-kernel-owner+w=401wt.eu-S964924AbXBOHHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbXBOHHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964946AbXBOHHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:07:55 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55204 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964924AbXBOHHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:07:54 -0500
Message-ID: <45D406BF.2060009@bull.net>
Date: Thu, 15 Feb 2007 08:07:43 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>	<20070116063030.761795000@bull.net>	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>	<m1mz3poeda.fsf@ebiederm.dsl.xmission.com> <45CC68BA.4010403@bull.net>	<m11wkz5gd2.fsf@ebiederm.dsl.xmission.com> <45D17F8D.3020207@bull.net> <m14ppqtlk3.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m14ppqtlk3.fsf@ebiederm.dsl.xmission.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/02/2007 08:05:52,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/02/2007 08:05:55,
	Serialize complete at 15/02/2007 08:05:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Nadia Derbey <Nadia.Derbey@bull.net> writes:
> 
> 
>>So, should I understand from this that automatic tuning and the AKT framework
>>itself would make sense, given that I find the rigth tunables it should be
>>applied to?
> 
> 
> Sort of.  The concept of things tuning themselves automatically makes
> a lot of sense.
> 
> I'm not at all certain about tunables being exported just to be hidden
> again.  Ideally you don't even want the fact that these things are
> varying visible to the user.
> 
> So I think that if you can find a good example that cannot be solved
> better another way, you can build a case for your framework.
> Currently I am doubt you can find such a case.
> 
> 
>>Actually, dont' know if you had the opportunity to read all the patches, but
>>there are 2 other tunables AKT is proposed to be applied to:
>>. max_threads, the tunable limit on nr_threads
>>. max_files, the tunable limit on nr_files
> 
> 
> At a quick glance max_threads and max_files appear even more to be
> DOS limits and not tunables and even less applicable to needing any
> tuning at all.  My gut feel is at worst these values may need a little
> better boot time defaults but otherwise they the should be good.
> 
But, what do you do with Oracle that's asking maxfiles to be set to 
0x10000, while the default value might be enough for a system that's not 
running Oracle.
I'm afraid that giving boot time values to the max_* tunables we will 
loose all the benefits from /proc (or /sys): it is impossible to 
anticipate what an OS will be used for. So allowing such things to be 
changed without having to reboot the machine is in my mind quite a 
powerful feature we should keep taking adavntage of.

Regards,
Nadia
