Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZFDIsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZFDIsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZFDIr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:47:57 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64378 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbZFDIr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:47:56 -0400
Message-ID: <4A2789D2.2000001@atmel.com>
Date: Thu, 04 Jun 2009 10:46:10 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] at91: Support for at91sam9g45: clocks management
References: <0c80319114935c723d3bac8992e6b4d8fc464b0b.1244104624.git.nicolas.ferre@atmel.com> <4a78a0b84331f1fb5ea111657992b3557f70a1b3.1244104625.git.nicolas.ferre@atmel.com> <20090604083332.GA3331@fluff.org.uk>
In-Reply-To: <20090604083332.GA3331@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks :
> On Thu, Jun 04, 2009 at 10:48:01AM +0200, Nicolas Ferre wrote:
>> Add the at91sam9g45 series support to the AT91 generic clock file.
>> This takes care of the particularities of the PMC for this series.
>> It also takes advantage of the management by functionalities of
>> those PLLs and clocks.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> personally, please don't post between open and subscriber only lists,
> this should really only be sent to linux-arm-kernel.

Ah ? Reading SubmittingPatches document, I see in section 6:
"Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org"

Is posting in "open" and "subscriber only" lists is a reason?


>> ---
>>  arch/arm/mach-at91/clock.c |   62 ++++++++++++++++++++++++++++++++++++-------
>>  1 files changed, 52 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
>> index bac578f..6396680 100644
>> --- a/arch/arm/mach-at91/clock.c
>> +++ b/arch/arm/mach-at91/clock.c
>> @@ -47,20 +47,25 @@
>>   * Chips have some kind of clocks : group them by functionality
>>   */
>>  #define cpu_has_utmi()		(  cpu_is_at91cap9() \
> 
> how does this pass checkpatch? no spaces after (.

Well, true, it does not. But, have a look at the result, it is so
prettier with those spaces: cpu_is_ directives are aligned.

It's a matter of taste and I considered breaking the rule here was not
so serious...

Thanks Ben.

Regards,
-- 
Nicolas Ferre

