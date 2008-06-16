Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYFPQ0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYFPQ0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYFPQ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:26:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:43344 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbYFPQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=T8F1dcw35lVYRvtPqI1+JLjsMo+/IdNx9M4iikEMA5LEDbVLji9+fPMShLFqFSUsnW
         b/hd0hhZ+PRsy2L7n5LveIqm0O9k0lBV7iShIddyOQCAW9uHO2j9cYmjRJphrr4/WD1z
         F03agVNIzyIWY1JuBzK22voF35tdF+klkRgek=
Message-ID: <7c86c4470806160926x847cfe5k103fbfaf6cbfa724@mail.gmail.com>
Date: Mon, 16 Jun 2008 18:26:25 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [patch 06/21] perfmon2 minimal: X86 generic hooks
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080615112529.95efd539.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484dafd6.0407560a.301b.6595@mx.google.com>
	 <20080615112529.95efd539.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

Ok, I will fold those  chunks into the patch that adds the files,
i.e., perfmon-x86.diff

Thanks.


On Sun, Jun 15, 2008 at 3:25 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Stephane,
>
> On Mon, 09 Jun 2008 15:33:58 -0700 (PDT) eranian@googlemail.com wrote:
>>
>> +++ o/arch/x86/Makefile       2008-06-02 18:54:41.000000000 +0200
>> @@ -176,6 +176,8 @@
>>  core-y += arch/x86/kernel/
>>  core-y += arch/x86/mm/
>>
>> +core-$(CONFIG_PERFMON) += arch/x86/perfmon/
>
> Again, this needs to come after some code is added to arch/x86/perfmon/
> so that bisections still work.
>
>> +++ o/include/asm-x86/Kbuild  2008-06-02 18:54:41.000000000 +0200
>> @@ -11,6 +11,7 @@
>>  header-y += sigcontext32.h
>>  header-y += ucontext.h
>>  header-y += processor-flags.h
>> +header-y += perfmon.h
>
> And this bit should go in the patch that adds that file.
>
>> +++ o/arch/x86/Kconfig        2008-06-02 18:54:41.000000000 +0200
>> @@ -1306,6 +1306,8 @@
>>
>>         If unsure, say Y.
>>
>> +source "arch/x86/perfmon/Kconfig"
>
> Same here.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
