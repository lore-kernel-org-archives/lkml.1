Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYJWNvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYJWNvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYJWNvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:51:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47846 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751890AbYJWNvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:51:21 -0400
Message-ID: <49008195.9070800@sgi.com>
Date: Thu, 23 Oct 2008 06:52:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/35] cpumask: accessors to manipulate	possible/present/online/active
 maps From: Rusty Russell	<rusty@rustcorp.com.au>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023020831.698704000@polaris-admin.engr.sgi.com> <20081023110524.GB25132@elte.hu>
In-Reply-To: <20081023110524.GB25132@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> +void set_cpu_possible(unsigned int cpu, bool possible)
>> +{
>> +	if (possible)
>> +		cpumask_set_cpu(cpu, &cpu_possible_map);
>> +	else
>> +		cpumask_clear_cpu(cpu, &cpu_possible_map);
>> +}
>> +void set_cpu_present(unsigned int cpu, bool present)
>> +{
> 
> i added the missing newlines between all the new function definitions.
> 
> 	Ingo

Thanks!  I normally do this when spotting them.
