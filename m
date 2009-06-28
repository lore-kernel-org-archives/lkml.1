Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZF1Wug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZF1Wug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZF1Wu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:50:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:21553 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbZF1Wu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uJqcEoVw+0Qj3S3Ag4MDLBEcUqaIr1Nx0TqCWttTEk36by53UG1hD+4EC1MRUNmb1l
         vJ5eD3irTsanjemjVHOvOtKfRgX3I2mE6dy5YB2R13RuSkD/JvfPuvK1vv9ol4Sm+yvN
         Hw0ZrGuWFCFY0hScZ0Mp6vCGwrH3S3TxvlgAA=
Message-ID: <4A47F3F5.4020405@gmail.com>
Date: Sun, 28 Jun 2009 15:51:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] acpi processor: simplify needlessly complex printk
References: <200906282203.55643.elendil@planet.nl> <4A47E85D.3020202@gmail.com> <200906290028.33285.elendil@planet.nl>
In-Reply-To: <200906290028.33285.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Monday 29 June 2009, Justin P. Mattock wrote:
>    
>> Would it be better to capitalize the S and add a period at the
>> end, or does it not matter?
>>      
>
> Kernel messages are in general not sentences.
>
> I thought of removing the parenteses, but if you look at the context of
> the message then that only makes sense if other messages are modified at
> the same time. The messages below appear together for my system and their
> consistency could definitely be improved, but IMO that's better done in a
> separate patch.
>
> ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> processor LNXCPU:00: registered as cooling_device7
> ACPI: Processor [CPU0] (supports 8 throttling states)
>
>    
Cool, thanks for the info.
I found Documentation/CodingStyle
Chapter 13: Printing kernel messages
Kernel messages do not have to be terminated with a period.
(Sh^t I was going to submit some patches that made proper
some messages, and comments)
I guess I have to learn to change code, instead of messages!

Justin P. Mattock
