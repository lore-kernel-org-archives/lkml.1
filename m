Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbYADKkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbYADKkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 05:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYADKke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 05:40:34 -0500
Received: from mga07.intel.com ([143.182.124.22]:30261 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbYADKkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 05:40:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,244,1196668800"; 
   d="scan'208";a="357521210"
Message-ID: <477E0CAB.2040402@linux.intel.com>
Date: Fri, 04 Jan 2008 02:38:35 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, olof@lixom.net
Subject: Re: [patch 2/2] Add the end-of-trace marker and the module list to
 WARN_ON()
References: <477D5340.9090809@linux.intel.com> <20080104074523.GD17447@elte.hu>
In-Reply-To: <20080104074523.GD17447@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
>> +	printk(KERN_WARNING "------------[ cut here ]------------\n");
>>  	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
>>  		line, function);
>> +	print_modules();
>>  	dump_stack();
>> +	print_oops_end_marker();
> 
> another thing: could we also put the marker into dump_stack(), and 
> attach the marker to the Call Trace line?
> 

I have a preliminary patch for that already but I'm not happy with it yet;
I need to redo it properly. It's neither depending nor incremental to these
2 patches though..
