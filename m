Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYGRL61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYGRL61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYGRL6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:58:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:2070 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYGRL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YdhXFxH4H18mMkT84x7zMDjB12xsFescn0LtHR3ml3ncqQh2w2z2RzZa1th7QcVbAF
         HBbm98OxYmv8IqGEHwbhNbh21X/2GucNl2sjXvvn9CgGkmze6JnaiyKF9oLsBBOrWcoV
         nBF9MZVuNSauDZyBwGZN8Ioz5hrLJmTykLr2o=
Message-ID: <19f34abd0807180458i2749f5d0jc5c07f691931954e@mail.gmail.com>
Date: Fri, 18 Jul 2008 13:58:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Josef Bacik" <jbacik@redhat.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Cc: "Andreas Dilger" <adilger@sun.com>, "Josef Bacik" <josef@toxicpanda.com>,
       linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080718112003.GC15844@unused.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717141333.GC14133@unused.rdu.redhat.com>
	 <20080717141655.GD14133@unused.rdu.redhat.com>
	 <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
	 <20080717143332.GE14133@unused.rdu.redhat.com>
	 <19f34abd0807170800q13cc021dyed27c665c25ac520@mail.gmail.com>
	 <20080717144342.GA15844@unused.rdu.redhat.com>
	 <20080717230905.GI6239@webber.adilger.int>
	 <20080718105152.GB15844@unused.rdu.redhat.com>
	 <19f34abd0807180432i19567dfal5d7d29bb1916b562@mail.gmail.com>
	 <20080718112003.GC15844@unused.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 1:20 PM, Josef Bacik <jbacik@redhat.com> wrote:
>> You can see the full log at
>> http://folk.uio.no/vegardno/linux/log-1216380709.txt which shows that
>> it already survived a lot of failures, so I'm guessing your patch was
>> correct and we just hit a different case. What do you think?
>>
>
> Yeah you are right, its like a shitty game of wack-a-mole.  Heres another patch,
> same thing as last time, pull the other one out put this one on.  Thanks,

It seems to hold up -- no stacktraces, but lots of IO failures.

I would leave it in testing for a bit more, but I've got to run; I'll
give it another go when I get home.

You may see the log so far: http://folk.uio.no/vegardno/linux/log-1216382128.txt


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
