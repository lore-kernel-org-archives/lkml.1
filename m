Return-Path: <linux-kernel-owner+w=401wt.eu-S1761056AbYDUTzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761056AbYDUTzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYDUTzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:55:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56153 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbYDUTzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:55:39 -0400
Date: Mon, 21 Apr 2008 21:55:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421195517.GH8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <480C8FD6.3030700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480C8FD6.3030700@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>> thanks, the three patches below should fix it.
>>
>> i ended up excluding Voyager configs from our test space some time 
>> ago (and VISWS as well - there's one more visws fix in x86.git), 
>> that's how this broke. These subarchitectures seem not to be used at 
>> all and the code wont boot on normal PCs. We could mark it BROKEN but 
>> the fix seems simple in any case.
>
> I talked to jejb about this, and pretty much the consensus was that if 
> it breaks, mark it BROKEN, and let him come back and catch up.  Under 
> those conditions, I'm willing to keep it in the tree.

sure - but no need to be rude and mark it BROKEN when we've got this 
much better tool named "email". BROKEN is really just for cases where 
there's no-one willing to fix things.

> VISWS is another matter.  It's entirely possible I have the only 
> remaining VISWS in my garage; we have at least not been able to locate 
> another.  Not that we have tried all that hard.
>
> If there are no VISWS' left, we should just unload the code.

ok, but there we should first mark it BROKEN, and after 1-2 kernel 
releases remove it so that there's adequate notice.

	Ingo
