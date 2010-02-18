Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab0BRTwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:52:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:37833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0BRTwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:52:39 -0500
Message-ID: <4B7D9A39.4070308@kernel.org>
Date: Thu, 18 Feb 2010 11:51:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH 3/3] genericirq: change ack/mask in irq_chip to take
 irq_desc in addition to irq
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org>	<m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org>	<m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org>	<m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org>	<m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org>	<4B7CAAEC.1000608@kernel.org> <m1r5oiv5ja.fsf@fess.ebiederm.org> <4B7D7552.2010001@zytor.com>
In-Reply-To: <4B7D7552.2010001@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 09:13 AM, H. Peter Anvin wrote:
> On 02/18/2010 09:04 AM, Eric W. Biederman wrote:
>>
>> May I ask why these methods and why pass both irq and desc instead of
>> just desc?
>>
>> I think in the long run passing both irq and desc through several
>> functions may incur some maintenance cost that it would be nice not to
>> pay (register pressure and increased chance of typos).
>>
> 
> Indeed; if the IRQ number is needed the function should just get it from
> desc->irq.


ok, change unsigned int irq to struct irq_desc *desc in irq_chip member...

YH
