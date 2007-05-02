Return-Path: <linux-kernel-owner+w=401wt.eu-S2992522AbXEBAbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992522AbXEBAbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992524AbXEBAbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:31:25 -0400
Received: from ozlabs.org ([203.10.76.45]:47294 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992522AbXEBAbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:31:24 -0400
Subject: Re: 2.6.22 -mm merge plans
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <p733b2gzqkg.fsf@bingen.suse.de>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <p733b2gzqkg.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 02 May 2007 10:31:10 +1000
Message-Id: <1178065870.28659.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 14:17 +0200, Andi Kleen wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> > Will merge the rustyvisor.
> 
> IMHO the user code still doesn't belong into Documentation.
> Also it needs another review round I guess. And some beta testing by
> more people.

Like any piece of code more review and more testing would be great.
(Your earlier review was particularly useful!).  But it's not clear that
waiting for longer will achieve either.

Look at kvm's experience for the reverse case: it went in, then got
rewritten.

As for the code in Documentation, my initial attempts tried to get
around the need for a userspace part by putting everything in the kernel
module.  It meant you could launch a guest by writing a string
to /dev/lguest (no real ABI burden there), but it's a worse solution
than some user code in the kernel tree 8(

Cheers,
Rusty.

