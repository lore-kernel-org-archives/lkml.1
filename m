Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZEOOhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZEOOhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZEOOh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:37:28 -0400
Received: from mail2.shareable.org ([80.68.89.115]:41369 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZEOOh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:37:27 -0400
Date: Fri, 15 May 2009 15:37:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, Josef Bacik <josef@redhat.com>,
       sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090515143726.GE8235@shareable.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com> <20090515093838.GB16682@one.firstfloor.org> <20090515134315.GB8235@shareable.org> <20090515140137.GF16682@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515140137.GF16682@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> > It would be quite nice if it were safe to call read(), get EFAULT
> 
> Even with that patch it is not safe, not even for write, because
> it's racy.

That's not necessarily a problem for the applications I described,
because they can be made to only increase access in parallel with
access; decreasing access can be synchronised over the whole program.

But I agree with you, as no application should depend on such subtle
details, which would probably be broken again in a future kernel anyway.

-- Jamie
