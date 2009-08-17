Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZHQPJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZHQPJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZHQPJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:09:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43467 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbZHQPI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:08:59 -0400
Date: Mon, 17 Aug 2009 17:08:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for
	vbus_driver objects
Message-ID: <20090817150844.GA3307@elte.hu>
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A8954F0.3040402@gmail.com> <20090817142506.GB3602@elte.hu> <4A8971A8.2040102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8971A8.2040102@gmail.com>
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


* Gregory Haskins <gregory.haskins@gmail.com> wrote:

> Hi Ingo,
> 
> 1) First off, let me state that I have made every effort to 
> propose this as a solution to integrate with KVM, the most recent 
> of which is April:
> 
>    http://lkml.org/lkml/2009/4/21/408
> 
> If you read through the various vbus related threads on LKML/KVM 
> posted this year, I think you will see that I made numerous polite 
> offerings to work with people on finding a common solution here, 
> including Michael.
> 
> In the end, Michael decided that go a different route using some 
> of the ideas proposed in vbus + venet-tap to create vhost-net.  
> This is fine, and I respect his decision.  But do not try to pin 
> "fracturing" on me, because I tried everything to avoid it. :)

That's good.

So if virtio is fixed to be as fast as vbus, and if there's no other 
techical advantages of vbus over virtio you'll be glad to drop vbus 
and stand behind virtio?

Also, are you willing to help virtio to become faster? Or do you 
have arguments why that is impossible to do so and why the only 
possible solution is vbus? Avi says no such arguments were offered 
so far.

	Ingo
