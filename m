Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZC3JBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZC3JBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZC3JA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:00:57 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57140 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbZC3JA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:00:56 -0400
Date: Mon, 30 Mar 2009 14:29:52 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
       Dhaval Giani <dhaval.lists@thegianis.in>, linville@tuxdriver.com,
       davem@davemloft.net, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090330085952.GB3837@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <20090107152208.GB4207@linux.vnet.ibm.com> <4964CAAA.3040801@gmail.com> <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com> <20090215134702.GA10180@hash.localnet> <49A9C3D7.8060706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A9C3D7.8060706@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 12:08:07AM +0100, Jiri Slaby wrote:
> On 15.2.2009 14:47, Bob Copeland wrote:
>> On Mon, Feb 02, 2009 at 01:27:39PM +0530, Dhaval Giani wrote:
>>> So I finally managed to hit this on 2.6.29-rc3. It is hard to
>>> reproduce, so I hope so much information is enough to give you a good
>>> guess. This time it hit while trying to connect to an open network at
>>> the airport.
>>
>>> WARNING: at net/mac80211/rx.c:2236 __ieee80211_rx+0x96/0x571 [mac80211]()
>>> Hardware name: 2007CS3
>>> RATE=255, BAND=8
>>
>> band is supposed to be sc->curband?  8 is way wrong.
>
> If you look into the patch which outputs this (backtrace in this  
> thread), sband->n_bitrates is 8. I have no idea what I have been smoking  
> the day I wrote it, but BAND= for sure isn't the right name for that  
> thing. Sorry for the confusion.
>
>> rate could be 255
>> if, for some reason, the hardware rate wasn't in the rate table.
>
> So, we have a fix for this, right? I mean the u8->s8 sc->rate_idx  
> conversion or alike...

Where is the fix? Is it merged in? I still see this happen on 2.6.29

thanks,
-- 
regards,
Dhaval
