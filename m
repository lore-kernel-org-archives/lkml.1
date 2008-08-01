Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbYHAUvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbYHAUvC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbYHAUux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:50:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYHAUux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:50:53 -0400
Date: Fri, 1 Aug 2008 16:50:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Message-ID: <20080801205052.GA28747@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <1217573919-7496-2-git-send-email-eric@anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217573919-7496-2-git-send-email-eric@anholt.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 11:58:38PM -0700, Eric Anholt wrote:
> From: Keith Packard <keithp@keithp.com>
> 
> GEM needs to create shmem files and get pages related to a shmem file, and
> using this pair of functions is the easiest way to do that.

Nope.  Let the userspace protion create a file in shmfs instead of
adding fugly kernel interfaces hdiing this fact.

