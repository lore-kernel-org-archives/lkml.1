Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZKCWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZKCWA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZKCWA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:00:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbZKCWA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:00:26 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH 0/5] cfq-iosched: improve latency for no-idle queues (v3)
References: <x49zl7c268s.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910271124r2cf9f9c0l83fdc59b50619202@mail.gmail.com>
	<x493a4wsn5c.fsf@segfault.boston.devel.redhat.com>
	<x49fx8wbqd0.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0911030042q5963718aj5875c542e6f6cc40@mail.gmail.com>
	<x49ocnju35d.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0911030719m425c208cg311f44a91fad8342@mail.gmail.com>
	<4e5e476b0911031035l7caffcb7n36b6eddd399864e7@mail.gmail.com>
	<20091103201802.GL8742@kernel.dk>
	<x49ocnjqrs5.fsf@segfault.boston.devel.redhat.com>
	<20091103202836.GM8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 03 Nov 2009 17:00:24 -0500
In-Reply-To: <20091103202836.GM8742@kernel.dk> (Jens Axboe's message of "Tue,
	3 Nov 2009 21:28:36 +0100")
Message-ID: <x49aaz3i807.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Tue, Nov 03 2009, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> 
>> > Since for-linus contains conflicting changes, can you and Jeff please
>> > double check that everything is still in order? The interesting bit here
>> > is the merge with for-2.6.33 and the coop limit from Shaohua Li. I did
>> > the straight forward merge, but we likely just need to drop that logic
>> > since the coop concept is radically different given that we merge and
>> > break queues in for-2.6.33.
>> 
>> Yeah, since I changed the meaning of the cfqq_coop flag, a lot of those
>> tests are just plain wrong.  Let me play with it and I'll send you an
>> incremental patch in a bit.
>
> Thanks, here's what I have. It's basically a revert of the commit in
> question.

Your patch looks like a straight-forward revert.  I still think we need
some guards in place, though.  For now, I think we can go with what you
have, and I'll come up with some other mechanism to deal with this case.

Cheers,
Jeff
