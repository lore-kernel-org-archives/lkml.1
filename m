Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZIFPJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZIFPJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 11:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbZIFPJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 11:09:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:41008 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757974AbZIFPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 11:09:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jg6hdn7/jp7pjzWrMD4tTqsWpUCM5mvmYDL5hC5
	RFB5Ccu2bLFXvY
Subject: RE: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       ani@anirban.org
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC482@exchange.ZeugmaSystems.local>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
	 <1252232289.29247.11.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC482@exchange.ZeugmaSystems.local>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 17:09:50 +0200
Message-Id: <1252249790.13541.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-06 at 07:53 -0700, Anirban Sinha wrote:
> 
> 
> 
> > Seems kjournald can end up depending on kblockd/3, which ain't
> > going anywhere with that 100% RT hog in the way,
> 
> I think in the past AKPM's response to this has been "just don't do
> it", i.e, don't hog the CPU with an RT thread.

Oh yeah, sure.  Best to run RT oinkers on isolated cpus.  It just
surprised me that the 100% compute RT cpu became involved in IO.

	-Mike

