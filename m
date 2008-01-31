Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbYAaR4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbYAaR4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762988AbYAaRz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:55:58 -0500
Received: from gw.goop.org ([64.81.55.164]:35134 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761157AbYAaRz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:55:57 -0500
Message-ID: <47A20B9D.3090700@goop.org>
Date: Thu, 31 Jan 2008 09:55:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Adrian Bunk <bunk@kernel.org>, wli@holomorphy.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       sparclinux@vger.kernel.org
Subject: Re: sparc compile error caused by x86 arch updates
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu> <20080131162920.GE19700@cs181133002.pp.htv.fi> <47A1FC6D.6090305@goop.org> <20080131174331.GA11881@elte.hu>
In-Reply-To: <20080131174331.GA11881@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> But I guess I overlooked the comment...
>>
>> I guess the fix is to scatter linux/pagemap.h into the appropriate 
>> places where these macros are used (asm-generic/tlb.h, for a start).
>>     
>
> no. The fix is always to undo the damage ASAP, to keep the window of 
> breakage minimized.
>   

Yes, sorry about that.  Uninlining the asm-x86/pgalloc.h functions is 
the right thing to do anyway.

    J
