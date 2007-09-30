Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbXI3R1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbXI3R1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbXI3R1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:27:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51849 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbXI3R1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:27:41 -0400
Date: Sun, 30 Sep 2007 19:27:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew <jackdachef@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
	v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20070930172736.GA12299@elte.hu>
References: <e85b9d30709290411u4f48d716o3260bab7d71261ff@mail.gmail.com> <20070930154354.GD24077@elte.hu> <e85b9d30709300943rded9801xddc6ca0a4773ff53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85b9d30709300943rded9801xddc6ca0a4773ff53@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.1.7-deb
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3664]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew <jackdachef@gmail.com> wrote:

> Thanks for your answer (sorry, I didn't know your email had changed)
> 
> well, this will take some time since I don't work every day & it's 
> turned off most of the time, hope that is OK
> 
> before I proceed with that data-collection:
> 
> do you think it is possible that it might be related to "Fair group 
> CPU scheduler" being selected ?

i think if you are relatively sure that the box does not have any real 
3D hardware in it (supported by X) then glxgears will interact badly 
with X and can cause such symptoms. In that case glxgears 'spams' the X 
server with requests and everyone else suffers from that. The fair-group 
scheduler indeed could shift CPU usage of X just enough (in X's favor!) 
that might trigger such problems. Such "spam X" workloads often react in 
a paradoxial way: a scheduler that gives X _more_ CPU time will appear 
to be "less interactive".)

	Ingo
