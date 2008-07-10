Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYGJG5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYGJG5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbYGJG5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:57:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:43644 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbYGJG5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fvRARPWRjENmiVDGs5Z8078YI9S1h4A+sK6ghnydut/kHCgWLMjVEsRijxZtjWqhLO
         u6IWhZ28ReVHYV4HkZJJoVpqLFLspKkR38hT6yBtOdD34igCh4iH5fxuVO4NB26OGZdw
         DM1yEzHbw8WahWCiOjx/gLy3pJpGTWu83C2DE=
Message-ID: <86802c440807092357x293224bfh212665a164a41553@mail.gmail.com>
Date: Wed, 9 Jul 2008 23:57:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20080710065316.GA14377@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <200807092015.03004.yhlu.kernel@gmail.com>
	 <20080710065316.GA14377@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2008 at 11:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> fix phys_pmd_init to make sure not to return big value than end.
>>
>> also print out range split:1G/2M/4K
>
> applied to tip/x86/core, thanks Yinghai. Lets hope it all goes well,
> this is a rather scary change - but it's also fairly clean.
>
> perhaps add a comment to the limit of 5 of mapping ranges - to point out
> that the number of mapping ranges depends on our programming, not on any
> external factor. I.e. if anyone adds a new mapping range to the kernel
> for any purpose, it must be extended - but otherwise it cannot run out
> due to new hardware.

4k, 2M, 1G, 2M, 4k

some day will get 512g page?

YH
