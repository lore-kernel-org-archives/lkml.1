Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYJQWtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYJQWtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYJQWtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:49:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbYJQWtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:49:45 -0400
Message-ID: <48F91673.6090901@zytor.com>
Date: Fri, 17 Oct 2008 15:49:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series
References: <20081007210056.GA5802@linux-os.sc.intel.com> <48EBCFF8.6050500@zytor.com> <20081007214920.GA17439@linux-os.sc.intel.com> <48EBEA97.9020404@zytor.com> <7E82351C108FA840AB1866AC776AEC4637B798D6@orsmsx505.amr.corp.intel.com> <48F8F1DB.9030202@zytor.com> <7E82351C108FA840AB1866AC776AEC4637B799FB@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4637B799FB@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
>>>
>> I guess I'm a bit confused about the tradeoff of CLFLUSH versus simply
>> disabling MWAIT.  This is a relatively recent processor and so
>> optimizing matters (if this was a P4 I would be more worried about what
>> has least impact on the kernel as a whole.)
> 
> As of now this is only for a limited models of CPUs (MP CPUs)
> and not a norm. It is a errata on this CPU and not
> something that is going to become architectural.
> 

Yes, I understand.  However, there is still the option to disable MWAIT, 
and the question is still open if it makes sense.

	-hpa
