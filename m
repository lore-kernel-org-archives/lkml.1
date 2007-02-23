Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXBWMSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXBWMSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 07:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXBWMSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 07:18:15 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:47965 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932274AbXBWMSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 07:18:14 -0500
Message-ID: <45DEDACE.2000601@aitel.hist.no>
Date: Fri, 23 Feb 2007 13:15:10 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
References: <20070220172544.15678.patches@notabene>	<1070220063516.16208@suse.de>	<20070221144806.e6eed85c.akpm@linux-foundation.org>	<17885.636.133245.572876@notabene.brown> <20070221185739.0d509c0d.akpm@linux-foundation.org>
In-Reply-To: <20070221185739.0d509c0d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 22 Feb 2007 13:39:56 +1100 Neil Brown <neilb@suse.de> wrote:
>
>   
>> I must right code that Andrew can read.
>>     
>
> That's write.
>
> But more importantly, things that people can immediately see and understand
> help reduce the possibility of mistakes.  Now and in the future.
>
> If we did all loops like that, then it'd be the the best way to do it in new code,
> because people's eyes and brains are locked into that idiom and we just
> don't have to think about it when we see it.
I have done lots of loops like that and understood it immediately.
Nice, short, _clear_ and no - a loop that counts down instead of
up is not difficult at all. 
Testing "i--" instead of "i >= 0" is also something I consider trivial,
even though I don't code that much.  If this is among the worst you
see, then the kernel source must be in great shape ;-)

Helge Hafting
