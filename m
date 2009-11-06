Return-Path: <linux-kernel-owner+w=401wt.eu-S1757634AbZKFOPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbZKFOPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbZKFOPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:15:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbZKFOPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:15:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Performance regression in IO scheduler still there
References: <20091026172012.GC7233@duck.suse.cz>
	<x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0911051500j7587dd6dh975148475418efcf@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 06 Nov 2009 09:14:53 -0500
In-Reply-To: <4e5e476b0911051500j7587dd6dh975148475418efcf@mail.gmail.com>
	(Corrado Zoccolo's message of "Fri, 6 Nov 2009 00:00:40 +0100")
Message-ID: <x494op7ivtu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> what hardware are you using for tests?
> I see aggregated random read bandwidth is larger than sequential read
> bandwidth, and write bandwidth greater than read.
> Is this a SAN with multiple independent spindles?

Yeah, this is a single path to an HP EVA storage array.  There are 24 or
so disks striped in the pool used to create the volume I am using.  Jan,
could you repeat your tests with /sys/block/sdX/queue/iosched/low_latency
set to 0?

Cheers,
Jeff
