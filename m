Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbYBGNvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbYBGNvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYBGNvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:51:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:40706 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYBGNvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:51:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PkQBneU+I7SQO7jO4xzwOnbuLlqho+K+360TzW4khyhyYRGo6CG+91RobIYKA5D79FfB6FH5FkJwgPxPRoQoNGQfoJHndMxwfUeZT6xxn6IjKzqdO8NriNO9vfVuJzXV28pgkxlWMm37jfWkv9VhSS9/PXtGx5sYj0hmqsJ9aCA=
Message-ID: <a4e6962a0802070551n3382940bpb6cd9d49ac55427b@mail.gmail.com>
Date: Thu, 7 Feb 2008 07:51:39 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PULL] v9fs patches for merge window
Cc: torvalds@linux-foundation.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080206184353.92ea8771.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4e6962a0802061739v6280c3acw1a7da77991037824@mail.gmail.com>
	 <20080206184353.92ea8771.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 6, 2008 8:43 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 6 Feb 2008 19:39:26 -0600 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:
>
> Could you please cc me on pull requests?  I need to pay more attention to
> them.  Thanks.
>
> > Andrew Morton (1):
> >       9p: fix p9_printfcall export
>
> Really this should have been folded into the patch which it fixes.  We get
> a cleaner history that way, and it protects git-bisectability.
>

I would have, but I didn't see the original offender in my upstream
branch, so I just applied it separately - looks to me like fcprint.c
hasn't been touched (until your patch) since its introduction:

ericvh@ericvh-desktop:~/src/linux/9p$ git log net/9p/fcprint.c
commit bd238fb431f31989898423c8b6496bc8c4204a86
Author: Latchesar Ionkov <lucho@ionkov.net>
Date:   Tue Jul 10 17:57:28 2007 -0500

    9p: Reorganization of 9p file system code

    This patchset moves non-filesystem interfaces of v9fs from fs/9p to net/9p.
    It moves the transport, packet marshalling and connection layers to net/9p
    leaving only the VFS related files in fs/9p.  This work is being done in
    preparation for in-kernel 9p servers as well as alternate 9p clients (other
    than VFS).

    Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
    Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>

            -eric
