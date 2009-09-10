Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZIJXbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZIJXbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZIJXbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:31:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57872 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZIJXbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:31:00 -0400
Message-ID: <4AA98BBE.20407@zytor.com>
Date: Thu, 10 Sep 2009 16:29:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] x86: increase MIN_GAP to include randomized stack
References: <20090908085328.GD22397@tiehlicka.suse.cz> <1252400515-6866-1-git-send-email-mhocko@suse.cz> <alpine.LNX.2.00.0909081107580.23856@wotan.suse.de> <alpine.LNX.2.00.0909110112470.23856@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0909110112470.23856@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 04:14 PM, Jiri Kosina wrote:
> On Tue, 8 Sep 2009, Jiri Kosina wrote:
> 
>>> Currently we are not including randomized stack size when calculating
>>> mmap_base address in arch_pick_mmap_layout for topdown case. This might
>>> cause that mmap_base starts in the stack reserved area because stack is
>>> randomized by 1GB for 64b (8MB for 32b) and the minimum gap is 128MB.
>>>
>>> If the stack really grows down to mmap_base then we can get silent mmap
>>> region overwrite by the stack values.
>>>
>>> Let's include maximum stack randomization size into MIN_GAP which is
>>> used as the low bound for the gap in mmap.
>>>
>>> Signed-off-by: Michal Hocko <mhocko@suse.cz>
>>
>> Acked-by: Jiri Kosina <jkosina@suse.cz>
>>
>> Ingo, could you please consider applying this?
> 
> Any comments about this patch please? (aka. "ping") :)
> 

Looks right to me... I'll apply it and see how it does.

	-hpa

