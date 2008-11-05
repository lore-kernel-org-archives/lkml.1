Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbYKEHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbYKEHwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 02:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYKEHwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 02:52:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:49787 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYKEHwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 02:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aCfeyUUoFZVb9NenruGNGOhxmOpyOXbNMpDfZCgSrrpzi1pf+5gMT90fEs2+7rTrpF
         EteIY6RonSggjwd5+XFSGu4M344H22cdWR0lOF8A9WzIudAO2HbJP5h6+fh+wwoYlwMD
         0VthepWoZ7zFUJbYvyiU0q1O8Dcq+vkd9UCuk=
Message-ID: <19f34abd0811042352q2df6ed0r6c92a35159d2b04c@mail.gmail.com>
Date: Wed, 5 Nov 2008 08:52:01 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: Git next: Second stage of cpu_alloc patches
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, travis@sgi.com,
       linux-next@vger.kernel.org
In-Reply-To: <20081105182642.8497301a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0811042053510.31638@quilx.com>
	 <20081104195205.fe1bf62b.akpm@linux-foundation.org>
	 <20081105182642.8497301a.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 8:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Christoph,
>
> On Tue, 4 Nov 2008 19:52:05 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Tue, 4 Nov 2008 20:56:52 -0600 (CST) Christoph Lameter <cl@linux-foundation.org> wrote:
>>
>> > The second stage of the cpu_alloc patchset can be pulled from
>> >
>> > kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2
>>
>> Please send the patches for review.  Always.
>
> And I would like to see a bit of positive feedback from the first set
> (given we have boot failures bisected down to this stuff) before we add
> more on top.

Thanks. I will try out today's linux-next later today (if I can find
the time for it).

Just in case it helps track down the problem: Adding percpu=100000 to
the kernel command line got the thing booting for me. The number
itself was picked at random, but it worked on the first try. The
machine is a single-core P4 3.0 GHz with HT, 1G RAM, using slightly
modified F9 config.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
