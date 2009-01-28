Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZA1R4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZA1R4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZA1R4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:56:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZA1R4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:56:15 -0500
Date: Wed, 28 Jan 2009 12:55:41 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128175541.GA7074@infradead.org>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com> <20090128173618.GA3174@infradead.org> <20090128104414.09aee3f9@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128104414.09aee3f9@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 10:44:14AM -0700, Jonathan Corbet wrote:
> If others disagree, and using bitops is not an idea which will fly, I'd
> sure like to know sooner rather than later.

There are more than enough use cases that have large numbers of open
files (e.g. various high-end network servers).  While it might not be
as sewer as for inodes I think it's really bad idea to do it for no
reason. 

