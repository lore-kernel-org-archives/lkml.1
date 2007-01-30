Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbXA3HGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbXA3HGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXA3HGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:06:45 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:60153 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbXA3HGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:06:44 -0500
In-Reply-To: <20070130055556.GA20699@in.ibm.com>
References: <Pine.LNX.4.64.0701292341070.32393@localhost.localdomain> <20070130055556.GA20699@in.ibm.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8DAAF0FE-E76A-4C1F-94B7-36BE839EA6BE@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net, Paul Mackerras <paulus@samba.org>,
       masami.hiramatsu.pt@hitachi.com
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH] kprobes: Fix compiler warning
Date: Tue, 30 Jan 2007 01:05:47 -0600
To: ananth@in.ibm.com
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 29, 2007, at 11:55 PM, Ananth N Mavinakayanahalli wrote:

> On Mon, Jan 29, 2007 at 11:43:33PM -0600, Kumar Gala wrote:
>> On ppc the compiler gripes about:
>>
>> kernel/kprobes.c: In function 'collect_garbage_slots':
>> kernel/kprobes.c:215: warning: comparison is always false due to  
>> limited
>> range of data type
>>
>> The compiler ends up optimizing away the test since char's are  
>> unsigned on
>> ppc.
>
> Kumar,
>
> Masami fixed this last week:
>
> http://marc.theaimsgroup.com/?l=linux-kernel&m=116968723823366&w=2
>
> Patch currently in -mm.
>
> Thanks,
> Ananth

Cool, Masami's patch looks far more complete.

- k

