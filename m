Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbYDVMnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbYDVMnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYDVMnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:43:22 -0400
Received: from ozlabs.org ([203.10.76.45]:48658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbYDVMnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:43:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18445.56653.957832.720681@cargo.ozlabs.ibm.com>
Date: Tue, 22 Apr 2008 22:42:53 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, anton@samba.org
Subject: Re: [PATCH 3/11] powerpc: convert to generic helpers for IPI function calls
In-Reply-To: <20080422121315.GE12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
	<1208851058-8500-4-git-send-email-jens.axboe@oracle.com>
	<18445.54284.194023.553595@cargo.ozlabs.ibm.com>
	<20080422121315.GE12774@kernel.dk>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe writes:

> I touched on both of these points in the initial mail, but perhaps you
> missed it as I didn't CC everyone for the 0/11 part. I'll add the full
> explanation to the 1/11 patch as well.

OK, that would be fine.  I didn't read right to the end of the 0/11
mail in detail, I admit. :)

Now that I have, I don't see anything about smp_send_stop trying to
get the interrupt sent off in a panic situation when some other cpu
might be stuck holding the lock (unless that's the "ipi_lock is a
little muddy" part, but that only talks about cpu onlining).  That bit
looks to be powerpc-specific, added in commit e057d985 in December
2007, so perhaps a mention that that has gone away now in the
description for 3/11 would be good.

Regards,
Paul.
