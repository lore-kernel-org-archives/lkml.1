Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYDJACf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYDJACf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYDJACX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:02:23 -0400
Received: from rtr.ca ([76.10.145.34]:1953 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbYDJACW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:02:22 -0400
Message-ID: <47FD590C.5020003@rtr.ca>
Date: Wed, 09 Apr 2008 20:02:20 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: yoshfuji@linux-ipv6.org, jeff@garzik.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <47FCF9DD.6080007@rtr.ca>	<20080410.023045.16227424.yoshfuji@linux-ipv6.org>	<47FD138B.2060801@rtr.ca> <20080409.152933.132174258.davem@davemloft.net>
In-Reply-To: <20080409.152933.132174258.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mark Lord <lkml@rtr.ca>
> Date: Wed, 09 Apr 2008 15:05:47 -0400
> 
>> But it would be far more useful for whoever has been working on the
>> stack to suggest some possible/likely commits to look at instead.
> 
> Personally all I see is that one side closes the socket before all
> data packets received have been read into the application, resulting
> in a (correct) reset going out.
> 
> I can't think of any change we've made over the course of this
> release that would change behvaior in that area.
> 
> So you will likely need to bisect.
..

Or I can ignore it, like the net developers, since I have a workaround.
And then we'll see what other apps are broken upon 2.6.25 final release.

Really, folks.  Bug reports are intended to *help* the developers,
not something to be thrown back in their faces.

There do seem to have been a *lot* of changes around the tcp closing/close
code (as I see from diff'ing 2.6.24 against latest -git).

*Somebody* is responsible for those changes.
That particular *somebody* ought to volunteer some help here,
reducing the mountain of commits to a big handful or two.

Cheers
