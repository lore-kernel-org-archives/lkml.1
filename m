Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYHRR23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYHRR23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbYHRR2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:28:20 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:62554 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbYHRR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ja+4DqqcO2Lgk4sLaMLMVBoZK7Ab2+COzKS5FZn31hiopK2UrTQbCKLe2/HetEQhnI
         oD9qMse+Ng7P1W6cA+ddG3YxHnXfs70f5KRAJjRHTH+oirtlxLXBSLbHqZ5t9/JUdM3y
         lvCgV7MrmWh8htLVLSrI/6rQ2Zcai7FODG00Q=
Date: Mon, 18 Aug 2008 21:28:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, macro@linux-mips.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/15] apic: unification series 5
Message-ID: <20080818172830.GC7237@lenovo>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com> <48A9AFC4.8060505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48A9AFC4.8060505@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Mon, Aug 18, 2008 at 10:22:12AM -0700]
> Cyrill Gorcunov wrote:
>>
>> With this series 32bit code compilation warns:
>>
>> arch/x86/kernel/apic_32.c: In function ‘end_local_APIC_setup’:
>> arch/x86/kernel/apic_32.c:1165: warning: ISO C90 forbids mixed declarations and code
>> arch/x86/kernel/apic_32.c: In function ‘disconnect_bsp_APIC’:
>> arch/x86/kernel/apic_32.c:1446: warning: ISO C90 forbids mixed declarations and code
>> cyrill@lenovo linux-2.6.git $ 
>>
>> So parenthesis will be needed to eliminate them... but
>> I think it could be too ugly... need some time to think.
>> So patches 8/15 and 10/15 sould be not applied for now - just review them.
>> Thanks for patience!
>>
>
> Typically, just move the declaration to the top of the function  
> (followed by a blank line.)
>
> 	-hpa
>
well in case of the patch 10/15 it's not good since I don't
want to waste even 4 bytes in stack for 64bit APIC :)
I guess gcc could find it and just eliminate - will take
a look.

		- Cyrill -
