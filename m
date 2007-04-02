Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXDBFzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXDBFzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXDBFzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:55:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbXDBFzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:55:31 -0400
Date: Mon, 2 Apr 2007 07:55:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nivedita Singhvi <niv@us.ibm.com>
Cc: Dave Sperry <dave_sperry@ieee.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Message-ID: <20070402055509.GC3284@elte.hu>
References: <461004CE.1030009@ieee.org> <461010F9.7040706@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461010F9.7040706@us.ibm.com>
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


* Nivedita Singhvi <niv@us.ibm.com> wrote:

> Dave Sperry wrote:
> >Hi
> 
> (adding netdev to cc list)

in general (except of course those netdev folks that are interested in 
-rt+networking performance matters) i'd suggest we analyze this in an 
-rt specific way - netdev shouldnt have to bother about this.

> And I'm assuming nothing very different in the stats or errors through 
> both runs?

one thing to check would be whether both kernels use the same 
clocksource, via:

 cat /sys/devices/system/clocksource/clocksource0/current_clocksource

but at first sight there's no clocksource related overhead in the 
oprofile.

	Ingo
