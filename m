Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYC1NtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYC1NtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 09:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYC1NtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 09:49:09 -0400
Received: from rtr.ca ([76.10.145.34]:2670 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbYC1NtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 09:49:08 -0400
Message-ID: <47ECF753.1070804@rtr.ca>
Date: Fri, 28 Mar 2008 09:49:07 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
Cc: David Brownell <david-b@pacbell.net>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Re: Kconfig RTC selection
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net> <47ECE9BB.3050006@imap.cc>
In-Reply-To: <47ECE9BB.3050006@imap.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> On Fri, 28 Mar 2008 02:49:41 -0700, David Brownell wrote:
>> It seems too many people are used to enabling a legacy RTC despite the 
>> Kconfig help/comments; the gentle approach hasn't worked.
> 
> Gentleness is not the point. The Kconfig help/comments where just
> not clear at all.
> 
> FWIW, it's still confusing to have an option "Enhanced Real Time
> Clock Support" under "Character Devices", then later an option
> "Real Time Clock" one level higher, none of the two in any way
> acknowledging the existence of the other one, and only after
> naively selecting both, you are told that there is some sort of
> conflict. Couldn't this be made more explicit, such as:
> - mentioning in both options' help text that the other one
>   shouldn't be selected at the same time (if that's true)
> - noting explicitly which of the two RTC options is the "legacy"
>   one (is it RTC_CLASS?)
> - enhancing the conflict message, which reads, in git-current:
>        *** Conflicting RTC option has been selected, check GEN_RTC
>        *** RTC interfaces ***
..

Exactly the issue.  Mod++++++++++++++++++++++

