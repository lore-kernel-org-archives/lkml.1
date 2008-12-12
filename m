Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbYLLJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbYLLJ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbYLLJ5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:57:55 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:27979 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907AbYLLJ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:57:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x3vQU26TkyTWLnCLIIAy9pTRXr5MchDSG1DQLDar60EEMjLKoI3c2b8cCC3vyIDMpG
         kbNaE5GQWMsdYXYUUd9rCltBcda7hm6CZeR396KPr5k8tP6VOFrKEdyydFTtqP5LX8td
         TlwFJX+9YXpavSjdMyQ9jkf8C9N2zrcRdXIXQ=
Message-ID: <aec7e5c30812120157k2fc800d9xc094f84b80d90945@mail.gmail.com>
Date: Fri, 12 Dec 2008 18:57:52 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "John Stultz" <johnstul@us.ibm.com>
Subject: Re: [PATCH] clocksource: pass clocksource to read() callback
Cc: linux-kernel@vger.kernel.org, rmk+lkml@arm.linux.org.uk,
       tony.luck@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, jdike@addtoit.com, wli@holomorphy.com,
       cooloney@kernel.org, ralf@linux-mips.org, lethal@linux-sh.org,
       geert@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       paulus@samba.org, mingo@redhat.com, davem@davemloft.net
In-Reply-To: <1229014876.8699.6.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211114802.17622.54609.sendpatchset@rx1.opensource.se>
	 <1229014876.8699.6.camel@jstultz-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 2:01 AM, John Stultz <johnstul@us.ibm.com> wrote:
> On Thu, 2008-12-11 at 20:48 +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> Pass clocksource pointer to the read() callback for clocksources.
>> This allows us to share the callback between multiple instances.
>>
>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>
> Acked-by: John Stultz <johnstul@us.ibm.com>
>
>> ---
>>
>>  Applies to linux-next 87602124ea74da54ae39e713a28d5593af9ad5ef
>>  May conflict with the arch_gettimeoffset patches on SuperH and Sparc.
>
> Don't worry about the arch_gettimeoffset conflict, its a low priority
> cleanup patch, so I can rework it on top of this.

Thank you, John. I don't mind either way.

I tried hard not to introduce any breakage with this patch, but I have
not cross-compiled it for anything except SuperH. So please test your
platform. Let me know if I managed to break something and I'll fix
things up.

I'm not sure exactly how and when this patch should be applied, but I
assume it's fairly late in the in the merge window?

I guess the liklieness of breakage will increase over time from now
on, so when the time is right please ping me and I'll up-port this
patch straight away.

Thank you.

/ magnus
