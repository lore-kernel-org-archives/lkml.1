Return-Path: <linux-kernel-owner+w=401wt.eu-S935183AbZLGONA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbZLGONA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935156AbZLGONA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:13:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935132AbZLGOM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:12:59 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	<4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	<4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	<20091206104950.GN8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 07 Dec 2009 09:13:00 -0500
In-Reply-To: <20091206104950.GN8742@kernel.dk> (Jens Axboe's message of "Sun,
	6 Dec 2009 11:49:50 +0100")
Message-ID: <x49iqciyis3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Sun, Dec 06 2009, Corrado Zoccolo wrote:
>> Hi Jeff,
>> I remember you saw large performance drop on your SAN for sequential
>> writes with low_latency=1.  Can you test if Shaohua's and this patch
>> fix allow to recover some bandwidth?  I think that enabling the queue
>> depth ramp up only if a sync request was delayed should disable it for
>> fast hardware like yours, so you should not be seeing the slowdown any
>> more.
>
> I queued this up for post inclusion into 2.6.33, with the time_after()
> fixed.
>
> The patch was word-wrapped, btw.

So in what branch can I find this fix?  Once I know that I can queue up
some tests.

Cheers,
Jeff
