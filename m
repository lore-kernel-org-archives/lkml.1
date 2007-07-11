Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXGKFxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXGKFxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXGKFxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:53:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56627 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXGKFxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:53:42 -0400
Date: Wed, 11 Jul 2007 11:33:09 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070711060309.GI2927@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710222942.382fc9ba.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 10:29:42PM -0700, Andrew Morton wrote:
> I'm inclined to take the cautious route here - I don't think people will be
> dying for the CFS thingy (which I didn't even know about?) in .23, and it's
> rather a lot of infrastructure to add for a CPU scheduler configurator
> gadget (what does it do, anyway?)

Hmm ok, if you think the container patches is too early for 2.6.23, fine.
We should definitely target to have it in 2.6.24, by which time I am
thinking the memory rss controller will also be in a good shape.

> We have plenty of stuff for 2.6.23 already ;)
> 
> Is this liveable with??

Fine. I will request you to enable group cpu scheduling in
2.6.23-rcX-mmY atleast, so that it gets some amount of testing. The
essential group scheduling bits is already in Linus' tree now (as part
of cfs merge), so what you need in -mm is a slim patch to hook it with Paul's 
container infrastructure (which I trust will continue to be in -mm until it goes
mainline). I will send across that slim patch later (to be included in
2.6.23-rc1-mm1 perhaps).

-- 
Regards,
vatsa
