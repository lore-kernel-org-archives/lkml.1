Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbYDUNo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbYDUNo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbYDUNoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:44:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbYDUNoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:44:17 -0400
Message-ID: <480C8FD6.3030700@zytor.com>
Date: Mon, 21 Apr 2008 09:00:06 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu>
In-Reply-To: <20080421120054.GA6788@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
>> I shouldn't send bug reports at 3 in the morning...
>>
>> Attached is the .config for both Voyager build errors I reported.
> 
> thanks, the three patches below should fix it.
> 
> i ended up excluding Voyager configs from our test space some time ago 
> (and VISWS as well - there's one more visws fix in x86.git), that's how 
> this broke. These subarchitectures seem not to be used at all and the 
> code wont boot on normal PCs. We could mark it BROKEN but the fix seems 
> simple in any case.
> 

I talked to jejb about this, and pretty much the consensus was that if 
it breaks, mark it BROKEN, and let him come back and catch up.  Under 
those conditions, I'm willing to keep it in the tree.

VISWS is another matter.  It's entirely possible I have the only 
remaining VISWS in my garage; we have at least not been able to locate 
another.  Not that we have tried all that hard.

If there are no VISWS' left, we should just unload the code.

	-hpa
