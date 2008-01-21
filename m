Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYAUJzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYAUJzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 04:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbYAUJzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 04:55:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46081 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844AbYAUJzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:55:35 -0500
Date: Mon, 21 Jan 2008 09:55:01 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vinay Sridhar <vinay@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RUSAGE_THREAD
Message-ID: <20080121095501.GB5333@infradead.org>
References: <1200558425.5992.17.camel@srivinay.in.ibm.com> <20080119011418.850DD26F9FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119011418.850DD26F9FD@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 05:14:18PM -0800, Roland McGrath wrote:
> +#define	RUSAGE_LWP	RUSAGE_THREAD	/* Solaris name for same */

Please don't add this to the kernel header.  If glibc really wants that
it can provide it in it's own headers.

