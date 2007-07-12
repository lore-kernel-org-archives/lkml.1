Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbXGLFad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbXGLFad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbXGLFaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:30:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44890 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXGLFaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:30:22 -0400
Date: Thu, 12 Jul 2007 11:09:35 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-ID: <20070712053935.GA31526@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710105240.GA20914@linux.vnet.ibm.com> <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com> <20070710115319.0bdaff34.akpm@linux-foundation.org> <20070711045516.GH2927@linux.vnet.ibm.com> <20070710222942.382fc9ba.akpm@linux-foundation.org> <6599ad830707111244g5da91426g79b01aef4302658@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830707111244g5da91426g79b01aef4302658@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 12:44:42PM -0700, Paul Menage wrote:
> >I'm inclined to take the cautious route here - I don't think people will be
> >dying for the CFS thingy (which I didn't even know about?) in .23, and it's
> >rather a lot of infrastructure to add for a CPU scheduler configurator
> 
> Selecting the relevant patches to give enough of the container
> framework to support a CFS container subsystem (slightly
> tweaked/updated versions of the base patch, procfs interface patch and
> tasks file interface patch) is about 1600 lines in kernel/container.c
> and another 200 in kernel/container.h, which is about 99% of the
> non-documentation changes.
> 
> So not tiny, but it's not very intrusive on the rest of the kernel,
> and would avoid having to introduce a temporary API based on uids.

Yes that would be good. As long as the user-land interface for process
containers doesn't change (much?) between 2.6.23 and later releases this
should be a good workaround for us.

-- 
Regards,
vatsa
