Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYDYHC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYDYHC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYDYHCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:02:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYDYHCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:02:49 -0400
Date: Fri, 25 Apr 2008 03:02:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mingo@redhat.com
Subject: Re: [PATCH] Drop "init_mm" from being exported via
	EXPORT_UNUSED_SYMBOL.
Message-ID: <20080425070247.GB13138@infradead.org>
References: <alpine.LFD.1.10.0804241728510.4087@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804241728510.4087@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 05:31:20PM -0400, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
>   since this was listed as removable as of 2.6.26, does that mean its
> removal can go into an appropriate tree now?  or would that mean
> *after* the release of 2.6.26?

Davem mentioned this has valid use-cases on non-x86 architectures
because it's exposed through mm macros.  So please audit it's users and
make sure the export is only dropped for architectures where it's not
actually needed.
