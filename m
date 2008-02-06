Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYBFWlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYBFWlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbYBFWlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:41:04 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35246 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbYBFWlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:41:03 -0500
Date: Wed, 6 Feb 2008 22:40:50 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>,
       Mika Lawando <rzryyvzy@trashmail.net>
Subject: Re: What is the limit size of tmpfs /dev/shm ?
In-Reply-To: <47AA2E40.2020701@zytor.com>
Message-ID: <Pine.LNX.4.64.0802062233090.22295@blonde.site>
References: <47A9CA0E.3030507@wpkg.org> <Pine.LNX.4.64.0802061517380.8470@blonde.site>
 <47AA0A2E.30701@zytor.com> <Pine.LNX.4.64.0802061938120.32204@blonde.site>
 <47AA102F.1070105@zytor.com> <Pine.LNX.4.64.0802062150440.16791@blonde.site>
 <47AA2E40.2020701@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, H. Peter Anvin wrote:
> 
> The specific application was this:
> 
> - extract a kernel tarball
> - "make distclean"
> - cp -al the resulting tree
> - apply a patch to each tree
> - do a diff between the trees
> - delete all files
> 
> ... repeat something like 20,000 times.

Right, thanks.

Certainly extracting a tarball can be a surprising challenge
for some filesystems.

And you remind me that of course, to the extent that a load is
about metadata (lots of creates for example), tmpfs can hardly
lose since its metadata never goes out to swap.  But there is
plenty of data in your test above.

Hugh
