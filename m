Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYLJGde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYLJGde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 01:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYLJGd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 01:33:27 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:20272 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYLJGd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 01:33:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MrMaMzck2/FsGIbVVYW+aQMqN3JPnElt23nH0n0MZF80J09SwWY6qtkp95DM2VVQJL
         k4JCHovmx9sqtjCDT4/dyIxXS9ynaPmj9f7vmPRdpnnwY4EQNyaIJW9mPYRcr8FQ2piY
         OI7nwHQlUOwlDuuyItdH81tHK214OxPCPIm5M=
Message-ID: <b9df5fa10812092228qe618ablaca61adc05f947ab@mail.gmail.com>
Date: Wed, 10 Dec 2008 12:28:14 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH ] x86 : Fix compilation warning on paravirt-spinlocks.c
Cc: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081208150942.GA22016@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10812080656l21385db3ob08fc4f9ad3f1f76@mail.gmail.com>
	 <20081208150942.GA22016@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/08, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
> no - this just works around the compiler warning.
>
>  Look at the real fix below i did some time ago. If you are into fixing
>  warnings you should try tip/master, that has a ton of warning fixes
>  already:
>
>   http://people.redhat.com/mingo/tip.git/README
>
>         Ingo
Thanks, Ingo for explanation. In 'default_spin_lock_flags' function ,
the 2nd argument unsigned long flags isn't used in the function. Is it
necessary to keep it ?

Thanks,
Rakib.
