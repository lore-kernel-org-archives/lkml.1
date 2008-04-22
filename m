Return-Path: <linux-kernel-owner+w=401wt.eu-S1764662AbYDVS4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764662AbYDVS4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762242AbYDVSvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:51:22 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764160AbYDVSvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:51:20 -0400
Date: Tue, 22 Apr 2008 20:51:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, anton@samba.org
Subject: Re: [PATCH 3/11] powerpc: convert to generic helpers for IPI function calls
Message-ID: <20080422185111.GS12774@kernel.dk>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-4-git-send-email-jens.axboe@oracle.com> <18445.54284.194023.553595@cargo.ozlabs.ibm.com> <20080422121315.GE12774@kernel.dk> <18445.56653.957832.720681@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18445.56653.957832.720681@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Paul Mackerras wrote:
> Jens Axboe writes:
> 
> > I touched on both of these points in the initial mail, but perhaps you
> > missed it as I didn't CC everyone for the 0/11 part. I'll add the full
> > explanation to the 1/11 patch as well.
> 
> OK, that would be fine.  I didn't read right to the end of the 0/11
> mail in detail, I admit. :)

I don't blame you :-)

> Now that I have, I don't see anything about smp_send_stop trying to
> get the interrupt sent off in a panic situation when some other cpu
> might be stuck holding the lock (unless that's the "ipi_lock is a
> little muddy" part, but that only talks about cpu onlining).  That bit
> looks to be powerpc-specific, added in commit e057d985 in December
> 2007, so perhaps a mention that that has gone away now in the
> description for 3/11 would be good.

Oh that, yes I'll add a description. I didn't really think there was
much need for it anymore, but it should at least be documented. The
ipi_lock stuff was really more about stopping IPIs completely, not the
smp_send_stop() panic() you described.

-- 
Jens Axboe

