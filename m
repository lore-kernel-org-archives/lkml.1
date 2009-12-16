Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbZLPO64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbZLPO64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbZLPO6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:58:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbZLPO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:58:52 -0500
Date: Wed, 16 Dec 2009 09:58:51 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: anyone including <linux/perf_counter.h>?
Message-ID: <20091216145851.GM28962@bombadil.infradead.org>
References: <alpine.LFD.2.00.0912160939510.7588@localhost> <20091216145120.GL28962@bombadil.infradead.org> <alpine.LFD.2.00.0912160955420.7853@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912160955420.7853@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 09:56:47AM -0500, Robert P. J. Day wrote:
> > See the comment at the top, it's being provided to provide the old
> > names to userspace for a short time, now that the functionality has
> > been renamed to perf_events.
> 
>   but if it's supposed to be providing info to user-space, shouldn't
> it be *exported* to user space?  it's not listed in
> include/linux/Kbuild.  or am i misunderstanding?
> 

No, you're quite correct, my guess would be that the original
perf_counter.h header-y line was renamed to perf_event.h, and someone
forgot to add a new one for the old header.

regards, Kyle
