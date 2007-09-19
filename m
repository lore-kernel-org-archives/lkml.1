Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbXISRbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbXISRbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXISRbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:31:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53924 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbXISRbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:31:31 -0400
Date: Wed, 19 Sep 2007 18:31:30 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/24] r/o bind mounts: elevate write count for some ioctls
Message-ID: <20070919173130.GF20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182725.93651460@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182725.93651460@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:25AM -0700, Dave Hansen wrote:
> 
> Some ioctl()s can cause writes to the filesystem.  Take
> these, and make them use mnt_want/drop_write() instead.
> 
> We need to pass the filp one layer deeper in XFS, but
> somebody _just_ pulled it out in February because nobody
> was using it, so I don't feel guilty for adding it back.

Ok.
