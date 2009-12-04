Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZLDOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZLDOUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZLDOUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:20:45 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:38098 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbZLDOUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z5pqD6RPUa3CmUAwunrT+nA3q2/sKBIYZPuwp1NpkYVv6Qb2zU5yPn3wAVxOIKHCD2
         teZ1pIuB6GatkRfBnBk9nnDiEjiSQ0TLSgTa3AASzDJakPz8FPhsJBVybBZzTOjLkQL1
         JXi3e3rWrjKN9cI6VS4Xjyd8G8WTXcqjElkcU=
MIME-Version: 1.0
In-Reply-To: <20091203194132.GA27666@n2100.arm.linux.org.uk>
References: <4B167281.1090708@gmail.com>
	 <20091203194132.GA27666@n2100.arm.linux.org.uk>
Date: Fri, 4 Dec 2009 22:20:51 +0800
Message-ID: <e68bb3470912040620v7d6d9c67s176f6e8aef8a3638@mail.gmail.com>
Subject: Re: [PATCH 4/4]ARM: NUC900: enable uart support for nuc932
From: Wan ZongShun <mcuos.com@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/4 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Wed, Dec 02, 2009 at 09:58:25PM +0800, Wan ZongShun wrote:
>> diff --git a/arch/arm/mach-w90x900/clock.h b/arch/arm/mach-w90x900/clock.h
>> index b9ea2e6..2a2a54a 100644
>> --- a/arch/arm/mach-w90x900/clock.h
>> +++ b/arch/arm/mach-w90x900/clock.h
>> @@ -14,8 +14,10 @@
>>
>>  #ifndef CONFIG_CPU_NUC932
>>  #define EXTCLK       15000000
>> +#define UARTCLK      11313600
>>  #else
>>  #define EXTCLK       27000000
>> +#define UARTCLK      57139200
>>  #endif
>
> As far as I can see, these are the only thing which prevent a single
> kernel being built to cover both NUC900 and NUC932.
>
> Can we make their selection something which is done at runtime instead
> of compile time?  This comments goes for patch 5837/1 in the patch
> system as well.
>
Do you mean that I should use following form instead?

"if (machine_is_nuc932evb())"
         code....


-- 
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
