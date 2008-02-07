Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYBGRg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYBGRg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYBGRgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:36:18 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:40706 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbYBGRgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:36:16 -0500
Message-ID: <47AB4188.1050104@qualcomm.com>
Date: Thu, 07 Feb 2008 09:36:08 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CPU isolation extensions
References: <47AA9807.7090402@qualcomm.com> <alpine.LFD.1.00.0802070903190.2883@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802070903190.2883@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Torvalds wrote:
> 
> On Wed, 6 Feb 2008, Max Krasnyansky wrote:
>> Linus, please pull CPU isolation extensions from
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git for-linus
> 
> Have these been in -mm and widely discussed etc? I'd like to start more 
> carefully, and (a) have that controversial last patch not merged initially 
> and (b) make sure everybody is on the same page wrt this all..

They've been discussed with RT/scheduler/cpuset folks.
Andrew is definitely in the loop. He just replied and asked for some fixes and
clarifications. He seems to be ok with merging this in general.

The last patch may not be as bad as I originally thought. We'll discuss it some
more with Andrew. I'll also check with Rusty who wrote the stopmachine in the 
first place. It actually seems like an overkill at this point. My impression is 
that it was supposed to be a safety net if some refcounting/locking is not fully 
safe and may not be needed or as critical anymore. 
I'm maybe wrong of course. So I'll find that out :)

Thanx
Max
