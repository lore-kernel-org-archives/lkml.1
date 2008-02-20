Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbYBTG1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbYBTG1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYBTG12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:27:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYBTG11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:27:27 -0500
Date: Wed, 20 Feb 2008 07:27:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Miller <davem@davemloft.net>, greg@kroah.com,
       akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of
	parent
Message-ID: <20080220062706.GB7493@elte.hu>
References: <20080219112146.GC7204@elte.hu> <20080219.034110.191579889.davem@davemloft.net> <200802191142.48891.yinghai.lu@sun.com> <20080219.145512.142721224.davem@davemloft.net> <86802c440802191510m7afc200eg979ebd4a1cf4a41f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440802191510m7afc200eg979ebd4a1cf4a41f@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > > can you check the 5/8? that will make sure every struct device get 
> > > numa_node get assigned.
> >
> > Why do we need to bother with that if the parent will have the 
> > necessary information for us here?
> 
> less code?
> 
> or some kind of usb or other bus interface. may have several level...

you mean it's a small optimization: otherwise every struct device (net 
dev, usb...) need to go back to find another pci device (parent or host 
controller) to use their numa_node.

	Ingo
