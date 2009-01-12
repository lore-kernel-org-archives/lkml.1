Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZALK57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZALK57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZALK5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:57:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:9439 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZALK5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:57:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hWkSe+fH+0lGk/Uzu0CsRX6eWCUj2MU6FlIMQ1bbnIR08/PRwf2k4M9DctOp73oBjp
         47+q8GDfW5TmLS080O5btgRYYTWAwL1wVmJr9oFcCpvT/S7KYZ3xv345Ze1xglGjAZMt
         Eo7AMZk0XJcXAkVq1iYrc+NmqUrkB9E03YCQE=
Message-ID: <3f9a31f40901120257m27a9b047kd8dcee2793467bb3@mail.gmail.com>
Date: Mon, 12 Jan 2009 16:27:48 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Cc: "Jiri Kosina" <jkosina@suse.cz>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       linux-kernel@vger.kernel.org,
       "Jaswinder Singh Rajput" <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090112105202.GF10405@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
	 <20090112105202.GF10405@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 4:22 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jiri Kosina <jkosina@suse.cz> wrote:
>
>> Hi,
>>
>> with Linus' tree (ae04d14015) doesn't build for me with
>>
>> arch/x86/kernel/ldt.c: In function 'alloc_ldt':
>> arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
>> arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
>>
>> Config on http://www.jikos.cz/jikos/junk/.config
>
> hm, it builds fine here with your config. Did .28 build fine for you? The
> only change to this file since .28 has been Jaswinder's "423a540: x86:
> ldt.c fix style problems".
>

No, it is not because of my patch but I will check for the solution.

Thanks,
--
JSR
