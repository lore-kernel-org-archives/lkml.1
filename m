Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbYCTIi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbYCTIi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 04:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYCTIit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 04:38:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44627 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYCTIis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 04:38:48 -0400
Date: Thu, 20 Mar 2008 04:38:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jon Masters <jcm@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320083839.GA3569@infradead.org>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320002835.384758480@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 08:27:41PM -0400, Mathieu Desnoyers wrote:
> There seems to be good arguments for markers to support proprierary modules. So
> I am throwing this one-liner in and let's see how people react. It only makes
> sure that a module that has been "forced" to be loaded won't have its markers
> used. It is important to leave this check to make sure the kernel does not crash
> by expecting the markers part of the struct module by mistake in the case there
> is an incorrect checksum.

I still disagree.  Markers are per defintion a very linux specific API
and thus should stay internal.

