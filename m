Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXICJRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXICJRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXICJR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:17:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41724 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbXICJR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:17:28 -0400
Date: Mon, 3 Sep 2007 10:16:39 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Rob Landley <rob@landley.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible fashion.
Message-ID: <20070903091639.GU21089@ftp.linux.org.uk>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <200709020344.51437.rob@landley.net> <46DA7A4C.6080501@zytor.com> <200709020605.00782.rob@landley.net> <m1d4x0zvri.fsf@ebiederm.dsl.xmission.com> <20070902200010.GS21089@ftp.linux.org.uk> <20070903083733.GA31880@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070903083733.GA31880@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 10:37:33AM +0200, Andi Kleen wrote:
 
> That would probably break near all init scripts out there.
> 
> Can't the file system not just be mounted with /proc together?

Won't be fun to implement.  Really.  BTW, I really wonder what will
happen if two processes step on a magic symlink at the same time -
ought to check if NFS use is broken.
