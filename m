Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYE2LXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYE2LXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbYE2LXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:23:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43020 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYE2LXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:23:24 -0400
Date: Thu, 29 May 2008 13:22:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Message-ID: <20080529112257.GA18130@elte.hu>
References: <20080526115628.GA31316@elte.hu> <20080529084524.GA24892@elte.hu> <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805291332401.16829@wrl-59.cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0916]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


after about 50 bootups i got a hung test again:

titan:~/tip> netstat -nt
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             
State
tcp        0      0 10.0.1.14:22                10.0.1.16:58062  ESTABLISHED
tcp        0      0 10.0.1.14:22                10.0.1.16:60109  ESTABLISHED
tcp        0  86368 10.0.1.14:43914             10.0.1.16:3632   ESTABLISHED

and this time with CUBIC_TCP disabled - so that was a red herring.

	Ingo
