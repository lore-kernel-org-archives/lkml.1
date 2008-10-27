Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYJ0PLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYJ0PLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYJ0PLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:11:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50786 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbYJ0PLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:11:38 -0400
Message-ID: <4905DA6E.9020403@sgi.com>
Date: Mon, 27 Oct 2008 08:12:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com> <20081025065627.GI27492@one.firstfloor.org>
In-Reply-To: <20081025065627.GI27492@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Cool, thanks!  I rewrote the patch to use current->pid, removing the
>> idle callback.
> 
> As a additional measure you could make the timer deferred when in 
> idle state.  Then you would only actually do something when 
> changing from idle to non idle or keeps being busy, but nothing 
> when a CPU stays idle for a longer time.
> 
> The frequency wouldn't necessarily be 1 second then though.
> 
> -Andi

Hi Andi,

Sorry, I didn't see this message until now.  I will look into doing this
and ask the hw group if it's acceptable to drop BMC records when the cpu
is idle.  (I think they may still want them since this might also be
confused with "the cpu is no longer uninterruptible".)

Thanks,
Mike
