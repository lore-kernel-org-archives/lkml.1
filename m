Return-Path: <linux-kernel-owner+w=401wt.eu-S1945971AbXDCV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945971AbXDCV0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945968AbXDCV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:26:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945964AbXDCV0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:26:16 -0400
Date: Tue, 3 Apr 2007 23:26:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "dave_sperry@ieee.org" <dasperry@comcast.net>
Cc: David Sperry <dave_sperry@ieee.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Improved UDP performance using 2.6.21-rc5-rt10
Message-ID: <20070403212611.GC28093@elte.hu>
References: <040320071326.11440.461256000007192600002CB02207300793979D9D0A9F9C0E0B@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <040320071326.11440.461256000007192600002CB02207300793979D9D0A9F9C0E0B@comcast.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* dave_sperry@ieee.org <dasperry@comcast.net> wrote:

> rt10 shows a big improvement over rt8
> 
> ##################################################
> etup                    Thruput      CPU% 
> Nvidia
> 2.6.21-rc5-rt8           938          65%
>    netperf @51
>    hardirq @50
>    softirq @50
> 
> Nvidia
> 2.6.21-rc5-rt10           938          32%
>    netperf @51
>    hardirq @50
>    softirq @50

cool! Btw., could you run the same but without running cyclesoak, and 
only watching the 'idle' metric in 'top' or vmstat? I found in my 
experiments that cyclesoak sometimes interfers with the workload - and 
the idle stats are precise and accurate on -rt. (they are not on 
vanilla)

	Ingo
