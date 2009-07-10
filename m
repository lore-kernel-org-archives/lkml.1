Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZGJJqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZGJJqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbZGJJqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:46:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56821 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZGJJqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:46:31 -0400
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already
 using mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com,
       cl@linux-foundation.org
In-Reply-To: <alpine.DEB.2.00.0907100233560.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb>
	 <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com>
	 <20090710084745.GA26752@elte.hu> <1247215920.32044.3.camel@penberg-laptop>
	 <20090710090351.GD14666@wotan.suse.de>
	 <1247217263.771.8.camel@penberg-laptop>
	 <20090710092921.GF14666@wotan.suse.de>
	 <alpine.DEB.2.00.0907100233560.14601@chino.kir.corp.google.com>
Date: Fri, 10 Jul 2009 12:46:29 +0300
Message-Id: <1247219189.771.19.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, 2009-07-10 at 02:41 -0700, David Rientjes wrote:
> The reason why I'd like to see slqb merged as a non-default alternative is 
> because it exposes the allocator to more benchmarking coverage than would 
> be possible in any other environment and attracts much more attention to 
> development for those who don't pull Pekka's tree directly.

Yes, we can do that. But I'm not going to ask Linus to pull something
that has known _boot-time_ bugs (that we haven't been able to figure out
in over three months!) because it's a pretty clear indication that we're
not on top of things yet.

So if you want to fast-track SLQB, feel free to help out Nick in
debugging that sucker ;).

			Pekka

