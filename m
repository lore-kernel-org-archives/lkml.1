Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbZCOV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbZCOV0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZCOV0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:26:04 -0400
Received: from gw.goop.org ([64.81.55.164]:43148 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbZCOV0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:26:02 -0400
Message-ID: <49BD7266.1090200@goop.org>
Date: Sun, 15 Mar 2009 14:25:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 12/24] x86-64: remove PGE from must-have feature list
References: <1236931920-6861-1-git-send-email-jeremy@goop.org> <1236931920-6861-13-git-send-email-jeremy@goop.org> <49BD70B3.3030703@zytor.com>
In-Reply-To: <49BD70B3.3030703@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>> --- a/arch/x86/include/asm/required-features.h
>> +++ b/arch/x86/include/asm/required-features.h
>> @@ -50,7 +50,7 @@
>>  #ifdef CONFIG_X86_64
>>  #define NEED_PSE	0
>>  #define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
>> -#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
>> +#define NEED_PGE	0
>>  #define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
>>  #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
>>  #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
>>     
>
> This should be conditionalized on CONFIG_PARAVIRT, since doing this
> removes real-hardware optimimizations.
>   

OK.  Can do the same for PSE.

    J
