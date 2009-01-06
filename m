Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZAFPbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZAFPbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZAFPbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:31:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:52821 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754001AbZAFPbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:31:18 -0500
Message-ID: <49637944.6000803@sgi.com>
Date: Tue, 06 Jan 2009 07:31:16 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Cliff Wickman <cpw@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: Re: [patch] x86: make UV support optional
References: <20090106060348.GA16738@wotan.suse.de> <20090106143330.GB18913@sgi.com> <49637090.8010501@sgi.com> <20090106152823.GB11114@elte.hu>
In-Reply-To: <20090106152823.GB11114@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> @@ -616,6 +616,7 @@ config MAXSMP
>>  	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
>>  	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
>>  	select CPUMASK_OFFSTACK
>> +	select X86_UV
>>  	default n
>>  	help
> 
> why not add this to X86_UV:
> 
> 	default MAXSMP
> 
> this way it still stays fully configurable, but it is default-enabled if 
> someone strives for a big SMP kernel.
> 
> 	Ingo

Yes, that does sounds better, thanks!

Mike
