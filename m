Return-Path: <linux-kernel-owner+w=401wt.eu-S1762195AbZBEBpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762195AbZBEBpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZBEBpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:45:19 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:55853 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbZBEBpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:45:17 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc3: weird process after resume
References: <878womf727.fsf@sycorax.lbl.gov>
	<20090204153954.844ac67b.akpm@linux-foundation.org>
Date: Wed, 04 Feb 2009 17:45:13 -0800
In-Reply-To: <20090204153954.844ac67b.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 4 Feb 2009 15:39:54 -0800)
Message-ID: <87hc39ejx2.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 04 Feb 2009 09:25:20 -0800
> Alex Romosan <romosan@sycorax.lbl.gov> wrote:
>
>> this is on a thinkpad t61p with an intel core2 cpu. i just noticed
>> that after resuming from suspending to memory i get a weirdly named
>> process. i did a ps before and after and the only difference was that
>> before i had this process:
>> 
>>   [hda0/1]
>> 
>> and after this one:
>> 
>>   [__?__;??____D__"?______]
>> 
>> with everything else being the same. the laptop seems to be working
>> fine and the problem could have been there for a while but i just
>> didn't notice it. i am including my .config file. let me know if you
>> need anything else.
>
> Were earlier kernels OK?  If so, which version?

i just tried 2.6.28 and there was no [hda0] kernel thread. 2.6.29-rc1
and rc2 never resumed from suspend so i couldn't really try it.

> What the heck is that kernel thread anyway?  It looks like something
> derived from an IDE device.

i have no idea. hda is the cdrom (the disk is sata and shows up as
sda).

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
