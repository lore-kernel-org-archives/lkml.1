Return-Path: <linux-kernel-owner+w=401wt.eu-S1765464AbZEAUIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765464AbZEAUIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765216AbZEAUHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:07:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34608 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764796AbZEAUHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:07:51 -0400
Message-ID: <49FB5686.8020908@redhat.com>
Date: Fri, 01 May 2009 13:07:34 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] export softirq_to_name symbol
References: <20090501193022.GB3111@redhat.com> <20090501195015.GA31694@infradead.org>
In-Reply-To: <20090501195015.GA31694@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2009 12:50 PM, Christoph Hellwig wrote:
> On Fri, May 01, 2009 at 03:30:22PM -0400, Jason Baron wrote:
>> hi,
>>
>> In response to a user request:
>>
>>
>> Export 'softirq_to_name' so that modules using the softirq tracepoints
>> can resolve the # to a name.
> 
> Please submit it together with the module that uses it.

I'm adding SystemTap support for the format strings in the TRACE_EVENT
macros.  The softirq's TP_fast_assign uses softirq_to_name, and so that
array is needed to prepare the softirq's trace string.

So, there's no explicit reference to the symbol in SystemTap -- it's
just indirectly referenced by the tracepoint declaration.

Thanks,

Josh
