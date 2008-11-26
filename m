Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYKZR6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYKZR6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYKZR6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:58:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:7470 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKZR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=N2J7H5fRoLuVD9SHDfQfNfcCevLSDxvDOsGlTsFD8ylp8A2JQBmYWJaEmGNAB+qN02
         CbGu4sTXwLh5r40tpyWnArjvk/gteQooTgvvLZRT4edYiMdANOBSDTrwmMGtTb7/UW7N
         vDrMzn6LoouRRubDZoO8zJ5RwsUHb91efLBcE=
Message-ID: <7c86c4470811260958r6861c2a9vdbf34318fd0da4e9@mail.gmail.com>
Date: Wed, 26 Nov 2008 18:58:01 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [patch 17/24] perfmon: X86 64-bit system calls support (x86)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
In-Reply-To: <20081126110510.GP6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c02.02a1660a.15f1.ffffdbb5@mx.google.com>
	 <20081126110510.GP6703@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done
Thanks.

On Wed, Nov 26, 2008 at 12:05 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> +#define __NR_pfm_create                              295
>> +__SYSCALL(__NR_pfm_create, sys_pfm_create)
>> +#define __NR_pfm_write                               (__NR_pfm_create+1)
>> +__SYSCALL(__NR_pfm_write, sys_pfm_write)
>> +#define __NR_pfm_read                                (__NR_pfm_create+2)
>> + __SYSCALL(__NR_pfm_read, sys_pfm_read)
>> +#define __NR_pfm_attach                              (__NR_pfm_create+3)
>> +__SYSCALL(__NR_pfm_attach, sys_pfm_attach)
>> +#define __NR_pfm_set_state                   (__NR_pfm_create+4)
>> +__SYSCALL(__NR_pfm_set_state, sys_pfm_set_state)
>
> Please use always absolute numbers. That's much nicer for people
> who grep for them.
>
> -Andi
>
>
