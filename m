Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZGWInd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZGWInd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZGWInd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:43:33 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58741 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZGWInc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M099zeicJpdFSbulnbnDR8janM6mz+tkpeu+oCZQMSbyzrzCVsDevxoC54uEVQWTqI
         aUF5H9lJDcPpfjrQYOvcrMswI9MhF5pCoDEkGu9pJV82JogFfxcQl46mfW++bevLW3bg
         sCFVBwosyz4rgIKbz+ggI1L65TwkDYSxtA2iA=
MIME-Version: 1.0
In-Reply-To: <a4423d670907170657o2c68c479j9b4810af5adad29f@mail.gmail.com>
References: <a4423d670907160148n66760052wbef60e4a2c3c7941@mail.gmail.com>
	 <alpine.LFD.2.00.0907162145140.3531@sony-vgn-z540>
	 <a4423d670907170657o2c68c479j9b4810af5adad29f@mail.gmail.com>
Date: Thu, 23 Jul 2009 12:43:30 +0400
Message-ID: <a4423d670907230143l78f324dewefa4cb8990ef4266@mail.gmail.com>
Subject: Re: next: sfi build fails when !CONFIG_ACPI
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-next <linux-next@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/17 Alexander Beregalov <a.beregalov@gmail.com>:
> 2009/7/17 Len Brown <lenb@kernel.org>:
>>> drivers/sfi/sfi_core.c: In function 'sfi_init':
>>> drivers/sfi/sfi_core.c:346: error: 'acpi_disabled' undeclared (first
>>> use in this function)
>>> drivers/sfi/sfi_core.c:346: error: (Each undeclared identifier is
>>> reported only once
>>> drivers/sfi/sfi_core.c:346: error: for each function it appears in.)
>>>
>>>
>>> $ grep ACPI .config
>>> # Power management and ACPI options
>>
>> It builds for me.
>> Please send me the complete failing .config
>
> Attached (x86_64)

Still fails for me in the same way,
X86_64
next-20090723
