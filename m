Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYL0Kgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYL0Kgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYL0Kg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:36:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:18157 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbYL0KgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:36:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xktxXkWAyq8vWh4a6VRayTnvVsJpI9nKRBmA6Ax9txtbHRnbFfOWqHSg2cpzfIqgDe
         PsD7I5wwcGzMgHIhJi+k11OPWt6E7CvUqbfPFC/0fE3MmkMwMdeFc7lmWYj+3A/Nzv2Z
         OkmQkqiseVfdDqW6dfp/bJhtq9H1TNwZCV7sE=
Message-ID: <3f9a31f40812270236x2441b567j2af59bf5d3dbbf74@mail.gmail.com>
Date: Sat, 27 Dec 2008 16:06:24 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: reboot.c declare port_cf9_safe before they get used
Cc: "Jaswinder Singh" <jaswinder@infradead.org>,
       "x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081227103141.GF14639@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230049288.14358.4.camel@jaswinder.satnam>
	 <20081227103141.GF14639@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

On Sat, Dec 27, 2008 at 4:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>>  #include <mach_ipi.h>
>> +#include "../pci/pci.h"
>
> could you send another patch that moves arch/x86/pci/pci.h to
> arch/x86/include/asm/pci_x86.h (and update all the pci.h include sites)?
>

Sure, I will send this patch today.

Thank you,

Jaswinder Singh Rajput.
