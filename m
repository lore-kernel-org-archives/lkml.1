Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbZFZQJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbZFZQJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbZFZQJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:09:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760745AbZFZQJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:09:08 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] cfq-iosched: move cfqq initialization out of cfq_find_alloc_queue()
References: <1246007120-24034-1-git-send-email-jens.axboe@oracle.com>
	<1246007120-24034-2-git-send-email-jens.axboe@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 26 Jun 2009 12:09:05 -0400
In-Reply-To: <1246007120-24034-2-git-send-email-jens.axboe@oracle.com> (Jens
	Axboe's message of "Fri, 26 Jun 2009 11:05:19 +0200")
Message-ID: <x49bpob9dum.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> We're going to be needing that init code outside of that function
> to get rid of the __GFP_NOFAIL in cfqq allocation.
>
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

This looks pretty straight-forward.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
