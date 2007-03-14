Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXCNUR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXCNUR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCNUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:17:57 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:58914 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933153AbXCNUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:17:57 -0400
Date: Wed, 14 Mar 2007 10:54:51 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <20070314061922.GR2986@holomorphy.com>
To: linux-kernel@vger.kernel.org
Cc: William Lee Irwin III <wli@holomorphy.com>
Message-id: <200703141054.56595.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
 <200703140209.58375.gene.heskett@gmail.com>
 <20070314061922.GR2986@holomorphy.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007, William Lee Irwin III wrote:
>> On Wednesday 14 March 2007, William Lee Irwin III wrote:
>> >On Tue, Mar 13, 2007 at 11:31:53PM -0400, Gene Heskett wrote:
>> >> Now, can someone suggest a patch I can revert that might fix this?
>> >> The total number of patches between 2.6.20 and 2.6.21-rc1 will have
>> >> me building kernels to bisect this till the middle of June at this
>> >> rate.
>> >
>> >4 billion patches could be bisected in 34 boots. Between 2.6.20 and
>> >2.6.21-rc1 there are only:
>> >
>> >$ git rev-list --no-merges v2.6.20..v2.6.21-rc1  |wc -l
>> >3118
>> >
>> >patches, requiring 14 boots. In general ceil(log(n)/log(2))+2 boots.
>> >
>> >Of course, this is a little optimistic because it assumes no
>> > additional breakage occurring at the various bisection points. In
>> > any event, assuming (pessimistically) 10 minutes per build, this is
>> > 280 minutes or 4 hours and 40 minutes of build time. I estimate the
>> > process should complete well before Friday of this week, never mind
>> > June.
>
>On Wed, Mar 14, 2007 at 02:09:57AM -0400, Gene Heskett wrote:
>> Chuckle, sorry to disappoint you wli, on that 32 cpu Niagra Con was
>> calling 'poor equipment', maybe.
>> Even using  ccache, its about 15-18 minutes per build, with another 10
>> to edit my build script and construct the kernel tree with the proper
>> patches applied.  Then a reboot, probably 10 minutes by the time I get
>> the nvidia driver installed for the new kernel and get startx'd, then
>> its another 2 hours or a bit less for an amanda run to test it.
>
>2 hours, 48 minutes times 13 boots (see the correction post) is 36
>hours, 24 minutes. One attempt a day (24 hours instead of 2 hours, 48
>minutes) yyields 2 weeks. So you're still done by April, not June.
>

Back to the original theme of this thread, 2.6.20.3 works, now I'm booted 
to 2.6.20.3-rdsl-0.30 and trying that.  And 10 minutes into it, its going 
to be good from the looks of an amstatus report.


>
>-- wli



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Ahead warp factor 1"
- Captain Kirk
