Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbYHZS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbYHZS6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbYHZS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:58:42 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50047 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbYHZS6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:58:41 -0400
Message-ID: <48B4523E.70501@ct.jp.nec.com>
Date: Tue, 26 Aug 2008 11:58:06 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: paulmck@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] rcuclassic: fix compiler warning
References: <48A9EC09.4060701@ct.jp.nec.com> <20080818232830.GG6732@linux.vnet.ibm.com>
In-Reply-To: <20080818232830.GG6732@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Mon, Aug 18, 2008 at 02:39:21PM -0700, Hiroshi Shimamoto wrote:
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>>   CC      kernel/rcuclassic.o
>> kernel/rcuclassic.c: In function 'rcu_init_percpu_data':
>> kernel/rcuclassic.c:705: warning: comparison of distinct pointer types lacks a cast
>> kernel/rcuclassic.c:713: warning: comparison of distinct pointer types lacks a cast
>>
>> flags should be unsigned long.
> 
> You beat me to it!
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Hi Ingo, could you please apply this?

thanks,
Hiroshi Shimamoto
