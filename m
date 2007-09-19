Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbXISRkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbXISRkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763422AbXISRin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:38:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47619 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762630AbXISRim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:38:42 -0400
Date: Wed, 19 Sep 2007 18:38:41 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 20/24] sys_mknodat(): elevate write count for vfs_mknod/create()
Message-ID: <20070919173841.GT20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182745.76F35ACB@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182745.76F35ACB@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:45AM -0700, Dave Hansen wrote:
> 
> This takes care of all of the direct callers of vfs_mknod().
> Since a few of these cases also handle normal file creation
> as well, this also covers some calls to vfs_create().
> 
> So that we don't have to make three mnt_want/drop_write()
> calls inside of the switch statement, we move some of its
> logic outside of the switch.

Ok.
