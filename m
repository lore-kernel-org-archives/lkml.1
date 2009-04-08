Return-Path: <linux-kernel-owner+w=401wt.eu-S1765437AbZDHO5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765437AbZDHO5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZDHO5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:57:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZDHO5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:57:31 -0400
Date: Wed, 8 Apr 2009 16:57:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
Message-ID: <20090408145715.GO12931@elte.hu>
References: <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080518qf81b483h6ed2bc9752ee0d1e@mail.gmail.com> <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu> <49DCBA61.8060507@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DCBA61.8060507@fastmail.fm>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Stone <jwjstone@fastmail.fm> wrote:

> Ingo Molnar wrote:
> > No, i mean, this approach should be changed, and i dont think any 
> > type cast change should go via any trivial tree. It's easy to mess 
> > it up. Please submit them to the maintainer trees
>
> Ok. I'll try and find appropriate CCs. I'm going out shortly so it 
> might take me a while.

Since you do many such patches it might make sense to script up a 
"who maintains what" kind of script - and share that script with 
lkml.

I have this silly little script:

  git log $@ | grep Signed-off-by: |
   cut -d: -f2 | cut -d\< -f1 |
    sort | uniq -c | sort -n

To find out any recent parties that touches a particular file. But 
it would be nice to somehow automate the pickup of mailing-list 
addresses from MAINTAINERS for example. We've literally got hundreds 
of email lists there.

It is not trivial to do though :-)

	Ingo
