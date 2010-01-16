Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326Ab0APVHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab0APVHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 16:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261Ab0APVHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 16:07:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0APVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 16:07:06 -0500
Message-ID: <4B522A61.2010504@zytor.com>
Date: Sat, 16 Jan 2010 13:06:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
References: <20100116170338.GA17175@elte.hu> <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2010 12:34 PM, Linus Torvalds wrote:
> 
> 
> On Sat, 16 Jan 2010, Ingo Molnar wrote:
>>
>> Cyrill Gorcunov (1):
>>       x86: kernel_thread() -- initialize SS to a known state
> 
> This looks bogus. Why does it do it only on x86-64?
> 
> Either people care about SS or they don't (the answer, I suspect, is "they 
> don't"). But if they care, we should do it on both 32-bit _and_ 64-bit, 
> no?
> 

It is bogus -- it's basically Xen braindamage.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

