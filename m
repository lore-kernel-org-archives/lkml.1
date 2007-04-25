Return-Path: <linux-kernel-owner+w=401wt.eu-S2993069AbXDYUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993069AbXDYUZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993089AbXDYUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:25:13 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993069AbXDYUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:25:11 -0400
Date: Wed, 25 Apr 2007 13:25:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Message-Id: <20070425132507.81e2b634.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704251717220.25153@server.thyself>
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net>
	<Pine.LNX.4.64.0704251717220.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007 17:20:37 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> On Wed, 25 Apr 2007, akpm@linux-foundation.org wrote:
> 
> > The mm snapshot broken-out-2007-04-25-02-49.tar.gz has been uploaded to
> >
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-25-02-49.tar.gz
> >
> 
> Was support for UnionFS deliberately removed in this release?
> 

Yes.  It throws a big reject against
security-prevent-permission-checking-of-file-removal-via-sysfs_remove_group.patch
which I don't have time to fix up.

This situation will remain until either that patch gets dropped or it goes
me->greg->mainline and then Jeff fixes up the unionfs tree.

