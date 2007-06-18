Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXFRIYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXFRIYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbXFRIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:23:58 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:36723 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbXFRIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:23:57 -0400
Date: Mon, 18 Jun 2007 10:23:43 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch] use __asm__ rather than asm in asm-s390/ptrace.h
Message-ID: <20070618082343.GB3580@osiris.boeblingen.de.ibm.com>
References: <200706180223.07122.vapier@gentoo.org> <20070618073605.GA3580@osiris.boeblingen.de.ibm.com> <1182154518.3335.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182154518.3335.4.camel@localhost>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:15:18AM +0200, Martin Schwidefsky wrote:
> On Mon, 2007-06-18 at 09:36 +0200, Heiko Carstens wrote:
> > Hmm.. spka is a sort of priviledged instruction and shouldn't be
> > user space visible.
> > I will move it so it's under #ifdef __KERNEL__.
> 
> Yes, I think this is better. On a side node, why did we add psw_set_key
> to ptrace.h? processor.h would have made more sense, no? It sets the key
> in the psw, it is not usable in userspace and ptrace doesn't provide an
> interface for reading/writing to the psw key. So a patch that moves the
> inline to processor.h alongside __load_psw and __load_psw_mask would be
> my solution.

Yes. Moved it to processor.h instead :)
