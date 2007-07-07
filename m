Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbXGGSIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbXGGSIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXGGSIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:08:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:36035 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXGGSIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aXPyGuwhhkj4PdeHW/Z1K1SBgrQT6q6v0DSA9umbanDKbZVPgYSZwN4dKBGZuYi9nKdDrQVW39/2zfxuw1k30RUU20TTTLFODsVUOmQk1GILLFY+pDdGhFjmJp6vghd0Qqx5rMllrDBNTDda/zhcDp871VZUyYVu6p0ZulcXLrQ=
Message-ID: <a781481a0707071108u7bedb6cfkc63067663ae619ca@mail.gmail.com>
Date: Sat, 7 Jul 2007 23:38:45 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Albert Cahalan" <acahalan@gmail.com>
Subject: Re: partially mounted cifs filesystem
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
In-Reply-To: <787b0d920707061845o6cf314dakf45c839c4fc0e600@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920707061845o6cf314dakf45c839c4fc0e600@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Albert,

[ added linux-cifs-client to Cc: ]

On 7/7/07, Albert Cahalan <acahalan@gmail.com> wrote:
> I had one share mounted, from XP to Linux, and wanted another.
> At first I had an incorrect setting on the XP box, almost
> certainly related to permissions. The mount failed of course.
> Running "mount" showed that the filesystem was not mounted,
> but apparently it didn't remain fully unmounted either.
> There was also nothing under the mount point, and the "ls -l"
> data (directory size and link count) looked like ext3.

That means nothing was mounted there ...

> I changed settings on the XP box numerous times. After many
> frustrating attempts, I ran "umount" on the mount point and
> then successfully mounted the filesystem.

... but still umount succeeded? Didn't it complain about nothing
being mounted there in the first place? Surprising that it actually
resolved the problem ...

> I'll guess that the kernel returned an error for my early
> attempts at mounting, but left open a CIFS connection.
>
> I suppose the cifs error handling is buggy.

Yes, that could be the case. Could you please:

1. Tell us which kernel version was it? .config?
2. Was there some dmesg output from the failed mount(2) attempt?
3. What was the mount command line / options?

Then:

1. Rebuild kernel with CIFS_DEBUG2.
2. Revert back (on the XP share export side) to the buggy / incorrect
settings -- so that you can try and reproduce the problem.
3. Let us know if you could reproduce, if so, any debug ouput / etc?

Thanks,
Satyam
