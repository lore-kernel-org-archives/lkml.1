Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYHHOPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYHHOPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 10:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYHHOPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 10:15:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47693 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbYHHOPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 10:15:36 -0400
Subject: Re: [PATCH][RESEND] scalable rw_mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Ryan Hope <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48f7fe350808080704j4162451bk19b9987258c0d060@mail.gmail.com>
References: <489B7DAD.3080104@gmail.com> <1218190862.8625.77.camel@twins>
	 <48f7fe350808080704j4162451bk19b9987258c0d060@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 16:15:23 +0200
Message-Id: <1218204923.8625.118.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

On Fri, 2008-08-08 at 10:04 -0400, Ryan Hope wrote:
> Sorry for not CCing you, I had intended to CC you and others but I
> clicked send too quick. One of the reiser4 todo's was remove all
> semaphore's, I didnt realize rw_semaphores were not real semaphores

Yeah, more people make that mistake. They're basically a sleeping rw
lock and already conform to the semantics that are required for lockdep
and are thus also already covered by lockdep.

> On Fri, Aug 8, 2008 at 6:21 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2008-08-07 at 18:56 -0400, Ryan Hope wrote:
> >> This was posted sometime last year I think and it never got merged. Can this get
> >> a go around in -mm, it would help in converting the semaphore's in reiser4 to
> >> mutexes.
> >
> > Thanks for CC'ing me :-/
> >
> > I dropped it because its only more scalable up to around 4 cpus.
> >
> > Also, how would it help reiser4? using rwsems is perfectly fine - as
> > they aren't actual semaphores.

<snip code>

