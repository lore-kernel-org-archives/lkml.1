Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0CIHGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:06:37 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:54871 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab0CIHGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:06:35 -0500
Message-ID: <4B95F339.5040903@st.com>
Date: Tue, 09 Mar 2010 12:35:29 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 07/11] ST SPEAr: Added source files for SPEAr3xx machine
 	family
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-7-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-8-git-send-email-viresh.kumar@st.com> <63386a3d1003082246g2752ccf4ob52d5bb01dfb264c@mail.gmail.com>
In-Reply-To: <63386a3d1003082246g2752ccf4ob52d5bb01dfb264c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 3/9/2010 12:16 PM, Linus Walleij wrote:
> Hi Viresh,
> some smallish comments...
> 
> 2010/3/3 Viresh KUMAR <viresh.kumar@st.com>:
> 
>> (skip some stuff that looks OK...)
>> diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
>> new file mode 100644
>> index 0000000..f529d74
>> --- /dev/null
>> +       .res = {
>> +               .start = SPEAR3XX_ICM1_UART_BASE,
>> +               .end = SPEAR3XX_ICM1_UART_BASE + SPEAR3XX_ICM1_UART_SIZE - 1,
>> +               .flags = IORESOURCE_MEM,
>> +               },
>> +       .irq = {IRQ_UART, NO_IRQ},
>> +       .periphid = 0x00041011,
>> +};
> 
> You're hardcoding the PrimeCell ID to the ARM version, but I suspect
> you have an ST derivate with some additional features. If you look in
> the PL011 driver in drivers/serial/amba-pl011.c you will probably recognize
> the modified PrimeCell IDs for vendor 0x80 (VENDOR_ST) and I think
> you might rather need to patch this file with your new periphid and
> possibly even implement some new extensions (if there are any).
> 
> What value is actually in the ID registers of your cell? (Just
> check in some debugger or simply printk() it...)
> 
> Apart from this the patch looks OK to me.
> 

Actually PL011 is customized by ST's nomadik platform. And hence above
is true for nomadik only. We are using ARM's version of PL011 without
any customization over it and so id for our case is still 0x00041011.

regards,
viresh kumar.
