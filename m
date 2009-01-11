Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbZAKO5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbZAKO5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZAKO45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:56:57 -0500
Received: from web.keli.cz ([77.48.235.227]:41902 "EHLO web.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbZAKO44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:56:56 -0500
Message-ID: <496A08AF.4000601@century.cz>
Date: Sun, 11 Jan 2009 15:56:47 +0100
From: Petr Titera <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29-rc1
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain> <4969E4D7.5050802@century.cz> <20090111135443.GA20288@elte.hu>
In-Reply-To: <20090111135443.GA20288@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a question. What is normal UP? Does simple disable of CONFIG_SMP 
suffice?

Petr

Ingo Molnar napsal(a):
> * Petr Titera <P.Titera@century.cz> wrote:
>
>   
>> Unfortunatelly it cannot be built without SMP support. This patch seems 
>> to fix it:
>>     
>
> Note, this build bug needs the !SMP + ACPI=y + X86_LOCAL_APIC=y 
> combination of configs to trigger. It wont trigger on normal UP nor on any 
> SMP config.
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

