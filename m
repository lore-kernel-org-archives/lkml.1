Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbYFJS4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbYFJS4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYFJS4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:56:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbYFJS4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:56:01 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2 of 7] block: Globalize bio_set and bio_vec_slab
References: <550d61001baa70aebab7.1212814535@sermon.lab.mkp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Jun 2008 14:55:43 -0400
In-Reply-To: <550d61001baa70aebab7.1212814535@sermon.lab.mkp.net> (Martin
	K. Petersen's message of "Sat, 07 Jun 2008 00:55:35 -0400")
Message-ID: <x49iqwh9l1s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> 2 files changed, 38 insertions(+), 28 deletions(-)
> fs/bio.c            |   36 ++++++++----------------------------
> include/linux/bio.h |   30 ++++++++++++++++++++++++++++++
>
>
> Move struct bio_set and biovec_slab definitions to bio.h so they can
> be used outside of bio.c.

Don't sell yourself short;  you also implemented bvec_nr_vecs.

Looks okay to me.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
