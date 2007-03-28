Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXC1XEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXC1XEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965810AbXC1XEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:04:38 -0400
Received: from mail20.syd.optusnet.com.au ([211.29.132.201]:36384 "EHLO
	mail20.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965805AbXC1XEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:04:36 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Date: Thu, 29 Mar 2007 09:44:45 +1000
User-Agent: KMail/1.9.5
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
References: <200703290237.38777.kernel@kolivas.org> <20070328184843.GA17420@elte.hu>
In-Reply-To: <20070328184843.GA17420@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703290944.45888.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 04:48, Ingo Molnar wrote:
> hm, how about the questions Mike raised (there were a couple of cases of
> friction between 'the design as documented and announced' and 'the code
> as implemented')? As far as i saw they were still largely unanswered -
> but let me know if they are all answered and addressed:

I spent less time emailing and more time coding. I have been working on 
addressing whatever people brought up.

>  http://marc.info/?l=linux-kernel&m=117465220309006&w=2

Attended to.

>  http://marc.info/?l=linux-kernel&m=117489673929124&w=2

Attended to.

>  http://marc.info/?l=linux-kernel&m=117489831930240&w=2

Checked fine.

> and the numbers he posted:
>
>  http://marc.info/?l=linux-kernel&m=117448900626028&w=2

Attended to.

> his test conclusion was that under CPU load, RSDL (SD) generally does
> not hold up to mainline's interactivity.

There have been improvements since the earlier iterations but it's still a 
fairness based design. Mike's "sticking point" test case should be improved 
as well.

My call based on my own testing and feedback from users is: 

Under niced loads it is 99% in favour of SD.

Under light loads it is 95% in favour of SD.

Under Heavy loads it becomes proportionately in favour of mainline. The 
crossover is somewhere around a load of 4.

If the reluctance to renice X goes away I'd say it was 99% across the board 
and to much higher loads.

> 	Ingo

-- 
-ck
