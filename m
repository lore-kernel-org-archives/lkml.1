Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXA2GFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXA2GFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933166AbXA2GFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:05:34 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:44830 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbXA2GFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:05:33 -0500
Message-ID: <45BD8EAA.7020804@kernel.org>
Date: Sun, 28 Jan 2007 22:05:30 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <20070125022338.GB22540@linux.vnet.ibm.com> <45B86E88.6020209@kernel.org> <20070125180158.GC1705@linux.vnet.ibm.com> <45B8FFBB.4090307@kernel.org> <20070129021126.GA8417@linux.vnet.ibm.com>
In-Reply-To: <20070129021126.GA8417@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Jan 25, 2007 at 11:06:35AM -0800, Josh Triplett wrote:
>> Paul E. McKenney wrote:
>>> On Thu, Jan 25, 2007 at 12:47:04AM -0800, Josh Triplett wrote:
>>>> One major item: this new test feature really needs a new module parameter to
>>>> enable or disable it.
>>> CONFIG_PREEMPT_RCU_BOOST is the parameter -- if not set, then no test.
>>> This parameter is provided by the accompanying RCU-boost patch.
>> It seems useful for rcutorture to use or not use the preempting thread
>> independently of CONFIG_PREEMPT_RCU_BOOST.  That would bring you from two
>> cases to four, and the two new cases both make sense:
>>
>> * CONFIG_PREEMPT_RCU_BOOST=n, but run rcutorture with the preempting thread.
>>   This configuration allows you to demonstrate the need for
>>   CONFIG_PREEMPT_RCU_BOOST, by showing what happens when you need it and don't
>>   have it.
>>
>> * CONFIG_PREEMPT_RCU_BOOST=y, but run rcutorture without the preempting
>>   thread.  This configuration allows you to test with rcutorture while running
>>   a *real* real-time workload rather than the simple preempting thread, or
>>   just test basic RCU functionality.
>>
>> A simple boolean module_param would work here.
> 
> OK, am finally with you.  See below for updated patch.

Looks good to me.

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Signed-off-by: Josh Triplett <josh@kernel.org>

- Josh Triplett

