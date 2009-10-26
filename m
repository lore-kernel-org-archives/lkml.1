Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZJZSes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZJZSes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZJZSes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:34:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48147 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753859AbZJZSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:34:47 -0400
Message-ID: <4AE5EBCD.7050503@sgi.com>
Date: Mon, 26 Oct 2009 11:34:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	<20091023233756.941535000@alcatraz.americas.sgi.com> <87ljiyy6s0.fsf@basil.nowhere.org>
In-Reply-To: <87ljiyy6s0.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> Limit number of microcode messages of the form:
>>
>> [   50.887135] microcode: CPU0 sig=0x206e5, pf=0x4, revision=0xffff001
> 
> Having a summary message that tells how many CPUs got updated at the
> end would seem like the right approach here.
> 
> -Andi
> 

I can do that if you think it's necessary.  I believe it still does
print the error information if one or more fails to update.

Thanks,
Mike
