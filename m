Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZAQNLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZAQNLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 08:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbZAQNLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 08:11:42 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:40162 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbZAQNLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:11:41 -0500
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Jan 2009 08:11:41 EST
Message-ID: <4971D3D5.6040801@superbug.co.uk>
Date: Sat, 17 Jan 2009 12:49:25 +0000
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jussi Laako <jussi@sonarnerd.net>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class
References: <4959198A.3020209@sonarnerd.net>	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net> <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>
In-Reply-To: <496C6294.2040707@sonarnerd.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> Peter Zijlstra wrote:
>> Well, that's not my problem is it ;-), just batter them with a
>> clue-stick, no need to fudge the kernel for that.
> 
> Sure, been doing that already... :)
> There's just sort of a huge gap between rt-schedulers and the normal
> scheduler.
> 
>> Right, which is where deadline scheduling would be nice. Once you start
>> running into the budget throttle you know you've got to start dropping
>> frames in order to keep up.
>>
>> The proposal is for it to start sending SIGXCPU once it starts
>> throttling tasks in order to notify them of missed deadlines etc.
> 
> For sure this is nice for certain tasks. I'm not entirely convinced if
> the average media player or Flash-plugin would or should start using these.
> 

There is never a need for media players to use this.
Media players have time stamps on the displayed frames.
If the timestamp on a frame indicates it has taken too long to decode
it, the media player just skips the frame until it reaches frames that
have non-expired time stamps. No need for any kernel help here.

