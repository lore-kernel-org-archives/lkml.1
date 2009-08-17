Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZHQOXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZHQOXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 10:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZHQOXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 10:23:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbZHQOXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 10:23:30 -0400
Date: Mon, 17 Aug 2009 16:23:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090817142310.GA3602@elte.hu>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <20090816071607.GB29537@elte.hu> <4A896112.9030407@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A896112.9030407@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anthony Liguori <anthony@codemonkey.ws> wrote:

> Ingo Molnar wrote:
>>> I think the reason vbus gets better performance for networking today 
>>> is that vbus' backends are in the kernel while virtio's backends are 
>>> currently in userspace.  Since Michael has a functioning in-kernel 
>>> backend for virtio-net now, I suspect we're weeks (maybe days) away 
>>> from performance results.  My expectation is that vhost + virtio-net 
>>> will be as good as venet + vbus.  If that's the case, then I don't 
>>> see any reason to adopt vbus unless Greg things there are other 
>>> compelling features over virtio.
>>>     
>>
>> Keeping virtio's backend in user-space was rather stupid IMHO.
>
> I don't think it's quite so clear.

in such a narrow quote it's not so clear indeed - that's why i 
qualified it with:

>> Having the _option_ to piggyback to user-space (for flexibility, 
>> extensibility, etc.) is OK, but not having kernel acceleration is 
>> bad.

	Ingo
