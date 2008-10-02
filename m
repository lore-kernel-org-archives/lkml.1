Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYJBOdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYJBOdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYJBOd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:33:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52605 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753441AbYJBOd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:33:27 -0400
Message-ID: <48E4DBC8.3070202@sgi.com>
Date: Thu, 02 Oct 2008 07:33:44 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       rpurdie@rpsys.net, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com> <20080922114820.GA13990@elte.hu> <48D7AEE6.7080804@sgi.com> <20080928194201.GA1310@ucw.cz> <48E3BE2D.4020606@sgi.com> <20081002083700.GB19993@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081002083700.GB19993@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> Pavel Machek wrote:
>>>> Another relevant point is that I will be adding a bit more functionality
>>>> to disable the timer interrupt on truly "idle" cpus (like have been idle
>>>> for some amount of seconds).  We would then use the "exit from idle"
>>>> callback to reestablish the timer interrupt.  [This would allow them to
>>>> enter power down states if appropriate.]
>>> Should you look at nohz instead of reinventing it? 
>> Thanks, I did look at it.  Quite complex.  Maybe I'm missing something
>> but I don't see how it fits in?  Are you saying I should be using
> 
> I seen your remark above about disabling timer interrupt on idle
> cpus. That's exactly nohz functionality, right? Maybe I misunderstood
> you and you meant "my monitoring interrupt" and not "generic system
> timer interrupt"?
> 
> 									Pavel

Ahh, yes, now I see... ;-)

And thanks for the pointer, I hadn't looked at this before.

In regards to "powering down" a UV system, it's not clear yet that it will
help much unless we can power down a whole lot more of the system than just
the cpus... ;-)  [but in reality, reducing power use any time you can is 
real necessity.]

Btw, are you ok with the remainder of the patch?

Thanks,
Mike
