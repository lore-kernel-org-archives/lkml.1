Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbZE1AYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbZE1AYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757895AbZE1AYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:24:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757880AbZE1AYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:24:08 -0400
Date: Wed, 27 May 2009 17:20:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Shields <mshields@google.com>
Cc: rdunlap@xenotime.net, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Doc fix: ext2 can only have 32,000 subdirs, not 32,768.
Message-Id: <20090527172045.f33b0b49.akpm@linux-foundation.org>
In-Reply-To: <63a2e74f0905181213r54a2d8b2tb7dcecd177d474c2@mail.gmail.com>
References: <63a2e74f0905181213r54a2d8b2tb7dcecd177d474c2@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 12:13:51 -0700
Michael Shields <mshields@google.com> wrote:

> ext2.txt says that dirs can have 32,768 subdirs, but the actual value
> of EXT2_LINK_MAX is 32000.
> ext3 is the same, but the doc does not mention it. __One of ext4's
> features is to "fix 32000 subdirectory limit".
> 
> --- linux-2.6.29.3/Documentation/filesystems/ext2.txt.orig 2009-05-08
> 15:47:21.000000000 -0700
> +++ linux-2.6.29.3/Documentation/filesystems/ext2.txt 2009-05-18
> 12:03:58.000000000 -0700
> @@ -322,7 +322,7 @@ an upper limit on the block size imposed
> __so 8kB blocks are only allowed on Alpha systems (and other architectures
> __which support larger pages).
> 
> -There is an upper limit of 32768 subdirectories in a single directory.
> +There is an upper limit of 32000 subdirectories in a single directory.
> 
> __There is a "soft" upper limit of about 10-15k files in a single directory
> __with the current linear linked-list directory implementation. __This limit
> --

The patch is wordwrapped and has weird non-ascii characters in the
changelog text.  I fixed all that up.  Please fix your email client for
future patches.

Please include a Signed-off-by:, as described in
Documentation/SubmittingPatches, thanks.


