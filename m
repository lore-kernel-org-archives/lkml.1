Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbXKAJia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbXKAJia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXKAJiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:38:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbXKAJiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:38:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] markers: modpost
In-Reply-To: Mathieu Desnoyers's message of  Wednesday, 31 October 2007 22:46:22 -0400 <20071101024622.GA3343@Krystal>
References: <200709192132.00873.vda.linux@googlemail.com>
	<20070921125819.GA13129@Krystal>
	<20070921133006.GF8964@redhat.com>
	<20070921133820.GD13129@Krystal>
	<20071015194120.GA22562@redhat.com>
	<20071015231209.GA18994@Krystal>
	<20071015235033.321E84D0389@magilla.localdomain>
	<20071025191722.GA6114@Krystal>
	<20071026142810.GA14814@redhat.com>
	<20071101010624.54D8D4D04AE@magilla.localdomain>
	<20071101024622.GA3343@Krystal>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20071101093725.891F34D04AE@magilla.localdomain>
Date: Thu,  1 Nov 2007 02:37:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If we want to do it safely, I think we should iterate from
> __start___markers to __stop___markers symbols of vmlinux and get the
> pointers to the name/format string pairs.
> 
> The same can then be done with modules using the __markers section.
> 
> Or maybe is there some reason not to do that ?

It's just rather a pain in the ass, a whole lot more fiddly work.
cf "somewhat crude" and "foreseeable future" in my patch's log entry.
Knock yourself out if you're looking for more tedious hacking to do in
modpost.c, but I say fix it when it breaks.


Thanks,
Roland
