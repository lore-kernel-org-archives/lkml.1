Return-Path: <linux-kernel-owner+w=401wt.eu-S968447AbXG3ULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968447AbXG3ULa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966935AbXG3ULU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:11:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55146 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763973AbXG3ULS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:11:18 -0400
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on
	software raid 5
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       xfs@oss.sgi.com, linux-raid@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 15:11:06 -0500
Message-Id: <1185826266.9448.5.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 10:29 -0400, Justin Piszcz wrote:

> Overall JFS seems the fastest but reviewing the mailing list for JFS it 
> seems like there a lot of problems, especially when people who use JFS > 1 
> year, their speed goes to 5 MiB/s over time and the defragfs tool has been 
> removed(?) from the source/Makefile and on Google it says not to use it 
> due to corruption.

The defragfs tool was an unported holdover from OS/2, which is why it
was removed.  There never was a working Linux version.  I have some
ideas to improve jfs allocation to avoid fragmentation problems, but jfs
isn't my full-time job anymore, so I can't promise anything.  I'm not
sure about the corruption claims.  I'd like to hear some specifics on
that.

Anyway, for enterprise use, I couldn't recommend jfs, since there is no
full-time maintainer.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

