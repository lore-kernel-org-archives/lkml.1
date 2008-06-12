Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbYFLPCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbYFLPCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYFLPCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:02:36 -0400
Received: from ag-out-0708.google.com ([72.14.246.250]:34180 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYFLPCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:02:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V0r1NCDTeHxIePvmgflPM772Pi3S+ZBiXfOmNyAwEiQX2fBpVAsOMESWfanpsHZ4sk
         2sZSABfc/9bW3CzckSunfdCSKeD7MEl6rTE9PR/jrsd6pRzkV5VfyyAjcDjOLlF8ODX0
         e/nrGmCghzG08DuQmFmlMevLGlFatnFP4yh4I=
Message-ID: <48513A85.7020002@gmail.com>
Date: Thu, 12 Jun 2008 10:02:29 -0500
From: Elijah Anderson <kd0bpv@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alessandro Suardi <alessandro.suardi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 8139cp/too support not accessible?
References: <4850C9F5.8000104@gmail.com> <5a4c581d0806120403n410b8deam627f4623d9b22a71@mail.gmail.com>
In-Reply-To: <5a4c581d0806120403n410b8deam627f4623d9b22a71@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you. That worked.

Sorry about the confusion, I just didn't know where else to ask. For 
future reference, what's a better list to ask for that sort of question?

Alessandro Suardi wrote:
> On Thu, Jun 12, 2008 at 9:02 AM, Elijah Anderson <kd0bpv@gmail.com> wrote:
>> Hey List,
>>
>> I will admit right off the bat that I'm new to interacting directly with the
>> kernel, much less building one.
>>
>> The issue I'm having is that my ethernet card requires either the 8139cp or
>> 8139too module. I don't remember which one, so I want to modularize them
>> both. Problem is, using $make xconfig; I can't select it. I have the
>> interface set to show me all the options, but the modules I need are grayed
>> out and I can't change the value.
>>
>> Using $make config; It doesn't show them, even if I say Y to "Prompt for
>> development and/or incomplete code/drivers"
>>
>> Is there a way to manually select those drivers for modularization, or am I
>> just missing a step somewhere?
>>
>> Thank you.
> 
> That's not really a kernel issue... however, since I have
>  that configuration (both drivers modular) at home, I
>  know it works :)
> 
> You probably haven't selected NET_PCI, which is the
>     entry described by
> 
>  "EISA, VLB, PCI and on board controllers"
> 
> The drivers you want depend on the above entry being selected.
> 
> --alessandro
> 
>  "Give me love / Or give me hate
>  Give me anything that's not just ok"
> 
>  (Sophia, 'Weightless')
