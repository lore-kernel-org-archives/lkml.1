Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbYHNUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbYHNUKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 16:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHNUKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 16:10:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:57147 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYHNUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 16:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dWTG+Pvecp1BXLL5iKBGvH+l9MmdXsMmjkH+vUAIsY/MoaXA1p8/TB9ISEcbkJiOa+
         Hox6njM4zNJvcJ/Jtq5wdRad2QIe55Esr1cfUuId/7skGU2Lcuf9bqniBQPWCqBTrAZL
         /UPD9pePl9a+iavSmE5wf52IA/K744NIF0AoM=
Message-ID: <aa79d98a0808141310o608bae0coc40329c22b5b6778@mail.gmail.com>
Date: Fri, 15 Aug 2008 00:10:32 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] x86: apic - unify sync_Arb_IDs
In-Reply-To: <Pine.LNX.4.55.0808142038320.7213@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080814183428.550709025@gmail.com>
	 <20080814184652.317090901@gmail.com>
	 <Pine.LNX.4.55.0808142038320.7213@cliff.in.clinika.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That happend sendmail/quilt sent mail by past :(. I'll fix and resend
tomorrow. thanks.

On 8/14/08, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:
>
>  Hmm, are you living in the past?
>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>>
>> diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
>> index 1d5f830..ec0f18f 100644
>> --- a/arch/x86/kernel/apic_32.c
>> +++ b/arch/x86/kernel/apic_32.c
>> @@ -919,8 +919,7 @@ void __init sync_Arb_IDs(void)
>>  	apic_wait_icr_idle();
>>
>>  	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
>> -	apic_write(APIC_ICR,
>> -		   APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
>> +	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG |
>> APIC_DM_INIT);
>>  }
>>
>>  /*
> [etc...]
>
>  Well, I think this one is backwards...  There are exceptions, but the
> general rule is to with within the width of the terminal.
>
>   Maciej
>
