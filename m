Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYFYXQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYFYXQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYFYXQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:16:29 -0400
Received: from gw.goop.org ([64.81.55.164]:34693 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbYFYXQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:16:29 -0400
Message-ID: <4862D1B9.7000603@goop.org>
Date: Wed, 25 Jun 2008 16:16:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove end_pfn in 64bit
References: <200806242213.15310.yhlu.kernel@gmail.com>	 <200806242214.09503.yhlu.kernel@gmail.com>	 <20080625154138.GC18796@elte.hu> <4862B915.3010001@goop.org>	 <86802c440806251457y134de928rb496da66becbe5cd@mail.gmail.com>	 <4862C4DA.9060004@goop.org> <86802c440806251614t68ec7bf9o8f39b8c31b245977@mail.gmail.com>
In-Reply-To: <86802c440806251614t68ec7bf9o8f39b8c31b245977@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> x86 64 bit that they are same. num_phypages = max_pfn
> 32 bit when HIGHMEM=y, it is same.num_phypages = max_pfn
>          when HIGHMEM=n, num_phypages = max_low_pfn
>   

OK, that makes sense.

Thanks,
    J
