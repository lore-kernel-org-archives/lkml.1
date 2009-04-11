Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbZDKWL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbZDKWL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 18:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZDKWLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 18:11:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:57474 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZDKWLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 18:11:44 -0400
Subject: Re: [PATCH] fuse: fix possible bug in fuse_direct_io on 64-bit
 system
From: Miklos Szeredi <mszeredi@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49DFBD0F.3030800@gmail.com>
References: <49DFBD0F.3030800@gmail.com>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 00:11:26 +0200
Message-Id: <1239487886.2062.2.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 23:41 +0200, Marcin Slusarz wrote:
> Fix possible bug on 64-bit system when user requests > 4GB of data by
> direct_io read/write, but provides smaller buffer.

Thanks.  A similar patch is already queued for the next -rc:

http://git.kernel.org/?p=linux/kernel/git/mszeredi/fuse.git;a=commit;h=ce60a2f15764f296b0467960759351702c7d2986

Miklos


