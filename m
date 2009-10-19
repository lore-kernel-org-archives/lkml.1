Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbZJSIC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbZJSIC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbZJSICz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:02:55 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47305 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbZJSICz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:02:55 -0400
Date: Mon, 19 Oct 2009 10:02:39 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] consider stack access while checking for alternate
 signal stack
Message-ID: <20091019080239.GB25783@Chamillionaire.breakpoint.cc>
References: <20091018191247.GA21844@Chamillionaire.breakpoint.cc>
 <20091019073358.GE17960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091019073358.GE17960@elte.hu>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar | 2009-10-19 09:33:58 [+0200]:

>> index 35e3bd9..520c489 100644
>> --- a/arch/avr32/Kconfig
>> +++ b/arch/avr32/Kconfig
>> @@ -70,6 +70,9 @@ config GENERIC_BUG
>>  	def_bool y
>>  	depends on BUG
>>  
>> +config STACK_STORE_POST
>> +	def_bool y
>> +
>>  source "init/Kconfig"
>>  
>>  source "kernel/Kconfig.freezer"
Haavard just nacked that part as I mixed up the 8bit AVR with the 32bit
version which is POST_DEC as well as the architectures. In that case
there are no POST_* architectures available.
So the question is should I leave dead code for further reference or
just remove it?

Sebastian
