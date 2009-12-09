Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZLISJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZLISJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZLISJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:09:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZLISJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:09:50 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	<4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	<4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	<x49ein6nx9k.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0912081243ra071947if9a3edae77fb3861@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 09 Dec 2009 13:09:49 -0500
In-Reply-To: <4e5e476b0912081243ra071947if9a3edae77fb3861@mail.gmail.com>
	(Corrado Zoccolo's message of "Tue, 8 Dec 2009 21:43:05 +0100")
Message-ID: <x49ocm8nhn6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> The numbers look good. Now, there is no penalty in having low_latency
> set for sequential writes, and just a small penalty for random ones.
> The fact that random reads are faster with low_latency set is interesting.
> Is the test is running with your patched tiobench (so that the number
> of random operations is comparable with sequential ones)?

No, I forgot all about that.  The number of random operations defaults
to 4000, which is pretty low.  I'll re-run the tests with a number
comparable to the sequential runs.  Sorry about that.

Cheers,
Jeff
