Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbZDQLFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbZDQLFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbZDQLEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:04:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:43593 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759303AbZDQLEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:04:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+mbTMZx4SmjSTurnB9tvSfNktHHQsVY1/rnDy56B
	aqtIjOAaDefpi/
Subject: Re: [PATCH] Add ext3 data=guarded mode
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
In-Reply-To: <1239910921.21233.98.camel@think.oraclecorp.com>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com>
	 <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com>
	 <1239910921.21233.98.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 13:04:36 +0200
Message-Id: <1239966276.8806.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 15:42 -0400, Chris Mason wrote:
> Hello everyone,
> 
> Here's an updated (v4) patch for ext3 data=guarded mode.  The first two
> patches in the series are unchanged, and it looks like Linus pulled them
> in this morning.
> 
> This version fixes the bug Mike Galbraith hit.  The problem was with
> writes to the last block in the file that made the file bigger but
> didn't actually add a new block.  Since the block wasn't new, it
> wouldn't get sent through the guarded code and the on disk i_size wasn't
> always updated.

FWIW, I booted my backup fs drive mounted data=guarded, and have been
hammering it steadily since 6 A.M. with no hint of trouble.

	-Mike

