Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYICSeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYICSeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbYICSeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:34:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYICSeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:34:15 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com
Subject: Re: [PATCH 3/6] Check for device resize when rescanning partitions
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231310.25065.40311.stgit@bluto.andrew>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 03 Sep 2008 14:17:34 -0400
In-Reply-To: <20080829231310.25065.40311.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:10 -0600")
Message-ID: <x49ej419jr5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson <andrew.patterson@hp.com> writes:

> Check for device resize when rescanning partitions
>
> Check for device resize in the rescan_partitions() routine. If the device
> has been resized, the bdev size is set to match. The rescan_partitions()
> routine is called when opening the device and when calling the
> BLKRRPART ioctl.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
