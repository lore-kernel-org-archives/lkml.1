Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbZE1Aak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbZE1Aak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZE1Aab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:30:31 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:54824 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZE1Aaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <20090528001418.GA2499@kroah.com>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> 
	<20090528001418.GA2499@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 28 May 2009 02:30:15 +0200
Message-ID: <ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 02:14, Greg KH <greg@kroah.com> wrote:
>
> So, there's been a lot of talk in this thread.
>
> Eric, do you have an updated set of patches for me to try out?

I think we should get a version of the patch in that removes all files
in a directory on cleanup, but warn if a subdirectory is still there.
James has a patch to fix the one issue we've seen so far with existing
child directories.

After that, we should work on fixing the users that leave files
behind, and can possibly stop cleaning up files, if we want to.

> Or are there still problems, like the "fry the ext3 boot partition" that
> Kay found?

That is unrelated to Eric's patches, They just added the dump, which I
tried to trigger. It's not entirely clear what caused the filesytem
damage, but I was definitely able to reproduce the unclean shutdown
without any of Eric's sysfs patches.

Thanks,
Kay
