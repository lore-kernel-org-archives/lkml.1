Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZJTX7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZJTX7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZJTX7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:59:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZJTX7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:59:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Zubin Dittia <zubin@tintri.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: libaio asynchronous syscall io_getevents blocks on error
References: <47c554d90910201458of5dc16eg33940584026bc959@mail.gmail.com>
	<x49ljj5og8q.fsf@segfault.boston.devel.redhat.com>
	<47c554d90910201634n68b359c1n501ed5669deb07be@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 20 Oct 2009 19:59:04 -0400
In-Reply-To: <47c554d90910201634n68b359c1n501ed5669deb07be@mail.gmail.com>
	(Zubin Dittia's message of "Tue, 20 Oct 2009 16:34:04 -0700")
Message-ID: <x4963a9obw7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zubin Dittia <zubin@tintri.com> writes:

> But this does bring up the interesting question of how to know which
> of the I/Os I submitted had an error, and what the error was.  Does it

If io_submit returned N, then the N+1 iocb had an error.

> PS: It does seem a little strange that io_submit returns an error if
> the first IOCB is invalid but not when any of the other IOCBs are
> invalid (this appears to be the case, at least according to the man
> page).

It makes sense that it tells you how many it could successfully submit.
If it can't submit any, you get the error from the first I/O.

Cheers,
Jeff
