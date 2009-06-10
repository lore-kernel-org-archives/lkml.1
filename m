Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZFJWbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZFJWbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZFJWbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:31:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZFJWbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:31:44 -0400
Message-ID: <4A30340C.9030402@zytor.com>
Date: Wed, 10 Jun 2009 15:30:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
References: <20090609082931.GD25316@prithivi.gnumonks.org> <4A2F353A.9040007@kernel.org> <20090610110244.GE27724@elte.hu> <200906100611.14941.lkml@morethan.org>
In-Reply-To: <200906100611.14941.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
>> yes, of course - i meant the /debug/x86/cpu/* behavior: it should 
>> either result zeroes, or should return -EINVAL. (probably the 
>> latter)
>>
> 
> Return zeroes - same as hardware case for bits which can't be set.
> Returning -EINVAL might match a specific bit pattern caller is looking for.
> 

It should be -EIO anyway, which is what /dev/cpu/*/msr does.

	-hpa
