Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYJCHTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYJCHTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYJCHTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:19:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbYJCHTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:19:14 -0400
Date: Fri, 3 Oct 2008 00:18:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Btrfs mainline plans
Message-Id: <20081003001859.e30af6a5.akpm@linux-foundation.org>
In-Reply-To: <1222717460.30627.56.camel@think.oraclecorp.com>
References: <1222717460.30627.56.camel@think.oraclecorp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 15:44:20 -0400 Chris Mason <chris.mason@oracle.com> wrote:

> But, the code is very actively developed, and I believe the best way to
> develop Btrfs from here is to get it into the mainline kernel (with a
> large warning label about the disk format) and attract more extensive
> review of both the disk format and underlying code.

For the record...  I have been encouraging Chris to get btrfs into
mainline soon.  Get it into linux-next asap and merge it into 2.6.29.

And do this even though the on-disk format is still changing - we emit a
loud printk at mount time and if someone comes to depend upon some
intermediate format, well, that's their tough luck.

My thinking here is that btrfs probably has a future, and that an early
merge will accelerate its development and will broaden its developer base. 
If it ends up failing for some reason, well, we can just delete it
again.


For various reasons this approach often isn't appropriate as a general
policy thing, but I do think that Linux has needed a new local
filesystem for some time, and btrfs might be The One, and hence is
worth a bit of special-case treatment.

