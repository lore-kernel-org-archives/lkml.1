Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXHTDlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXHTDlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbXHTDlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:41:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35573 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbXHTDk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:40:59 -0400
Date: Mon, 20 Aug 2007 04:40:43 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Satyam Sharma <satyam@infradead.org>, Anton Altaparmakov <aia21@cam.ac.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Message-ID: <20070820034043.GZ21089@ftp.linux.org.uk>
References: <20070819225546.GV21089@ftp.linux.org.uk> <200708191757.56520.david-b@pacbell.net> <alpine.LFD.0.999.0708200806380.2774@enigma.security.iitk.ac.in> <200708192026.24596.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708192026.24596.david-b@pacbell.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 08:26:24PM -0700, David Brownell wrote:

> ISTR the warning was the other way around:   about "cast from integer
> to pointer of a different size".  The __u64 came from userspace and
> the kernel pointer was only 32 bits.  Not really truncation, but GCC
> could not know that directly ... ergo the extra non-pointer cast.

And?  Cast to integer type with the size equal to that of pointer.
unsigned long is just that on all supported targets.

More interesting question is whether you want an error returned when
pointers are 32bit and value doesn't fit into that...
