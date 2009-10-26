Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbZJZR1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbZJZR1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZJZR1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016AbZJZR1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:27:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: jens.axboe@oracle.com, LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Performance regression in IO scheduler still there
References: <20091026172012.GC7233@duck.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 26 Oct 2009 13:26:54 -0400
In-Reply-To: <20091026172012.GC7233@duck.suse.cz> (Jan Kara's message of "Mon,
	26 Oct 2009 18:20:12 +0100")
Message-ID: <x49pr8avzfl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi,
>
>   I took time and remeasured tiobench results on recent kernel. A short
> conclusion is that there is still a performance regression which I reported
> few months ago. The machine is Intel 2 CPU with 2 GB RAM and plain SATA
> drive. tiobench sequential write performance numbers with 16 threads:
> 2.6.29:              AVG       STDERR
> 37.80 38.54 39.48 -> 38.606667 0.687475
>
> 2.6.32-rc5:
> 37.36 36.41 36.61 -> 36.793333 0.408928 
>
> So about 5% regression. The regression happened sometime between 2.6.29 and
> 2.6.30 and stays the same since then... With deadline scheduler, there's
> no regression. Shouldn't we do something about it?

Background:
  http://lkml.org/lkml/2009/5/28/415

Thanks for bringing this up again.  I'll try to make some time to look
into it if others don't beat me to it.

Cheers,
Jeff
