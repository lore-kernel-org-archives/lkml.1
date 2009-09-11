Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZIKNpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZIKNpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIKNpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:45:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbZIKNpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:45:30 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: What's in linux-2.6-block.git for 2.6.32
References: <20090911124106.GC14984@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 11 Sep 2009 09:45:29 -0400
In-Reply-To: <20090911124106.GC14984@kernel.dk> (Jens Axboe's message of "Fri,
	11 Sep 2009 14:41:07 +0200")
Message-ID: <x49d45xa93a.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> Hi,
>
> This is just the core block bits, I have other branches pending. And a
> heads up that I had to rebase this branch today, something I haven't
> done during the .31 cycle. This was due to the history being really odd,
> with modified patches of for-2.6.32 patches being forwarded to mainline.
> So I though it would be better to clean this history and merge fixups.
> There was also a middle point that would break bisection.
>
> Nothing really earth shattering in here, nor are there really big
> changes for this cycle.
>
> - Some updates to CFQ to improve interactiveness.
> - Some cleanups and sanitization of the bio IO flags.
> - blk-iopoll, an experimental API for doing NAPI like polled completions
>   for really fast devices. In testing this has shown to be faster for
>   some cases, while slower for others. The included patch is just the
>   core bits, no driver support is being merged yet.
> - Enable CPU IO completion by default. My testing has shown this to be
>   faster, and independent testing by Intel confirms that as well.
> - A fix to only issue a block queue trace when we actually intend to
>   queue.
> - A fix for splice to update mtime and atime on files.
> - A cleanup of the failfast bits and merge fixups for the same.

Any particular reason you're holding off on the pktcdvd regression fix I
posted?

Cheers,
Jeff
