Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790Ab0BQAoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:44:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:55989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933615Ab0BQAoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:44:01 -0500
Message-ID: <4B7B3B33.6010504@kernel.org>
Date: Tue, 16 Feb 2010 16:41:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 27/35] core: move early_res
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	<1265793639-15071-28-git-send-email-yinghai@kernel.org> <20100215011615.e3d35121.sfr@canb.auug.org.au> <4B786110.9020806@kernel.org> <4B7B2E3B.9060903@zytor.com> <4B7B2FE1.1030700@kernel.org> <4B7B31F1.60203@zytor.com>
In-Reply-To: <4B7B31F1.60203@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 04:01 PM, H. Peter Anvin wrote:
> On 02/16/2010 03:53 PM, Yinghai Lu wrote:
>>>
>>> All this does would seem is it would change a build failure into a
>>> runtime panic.  I really fail to see how this is an improvement...
>>
>> current only x86 support to early_res replace bootmem.
>>
>> later if other arch is using that feature, it need to provide that get_max_mapped.
>>
> 
> If so, it would be better if this code isn't compiled at all on
> platforms that doesn't use it.  Masking a compile-time failure with a
> runtime failure when the code isn't actually used doesn't seem like the
> right thing.

I would like to.

but for x86, with CONFIG_NO_BOOTMEM set or not, early_res are all used.

so we add CONFIG_HAVE_EARLY_RES ?

Yinghai
