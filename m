Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZKJWAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZKJWAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZKJWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:00:17 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:33587 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036AbZKJWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:00:16 -0500
X-Greylist: delayed 1260 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 17:00:16 EST
Message-ID: <4AF9DD24.8060501@lougher.demon.co.uk>
Date: Tue, 10 Nov 2009 21:37:40 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Phillip Lougher <phillip@lougher.demon.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, jblunck@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       matthew@wil.cx, viro@zeniv.linux.org.uk
Subject: Re: BKL: Remove BKL from Squashfs
References: <E1N5L6K-0008LW-6y@dylan.lougher.demon.co.uk> <20091110121511.5adca8a9.akpm@linux-foundation.org> <4AF9D6EE.1070205@lougher.demon.co.uk>
In-Reply-To: <4AF9D6EE.1070205@lougher.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Lougher wrote:

> This patch was prompted by Jan Blunck's "Push down BKL to the 
> filesystems" patch
> series, where he firstly pushes the BKL down to individual filesystems
> (even if they don't need it) , and then successively removes them
> (on a one patch per filesystem basis) in later patches.
> 
> The patch should be reviewed in the context that it is intended for Jan's
> BKL removal patch series.
> 

Jan and/or Matthew,

Can you please ACK this patch, and say whether you're going to
add it to your BKL patch series? (I'm happy for it to go through
there, rather than my Squashfs tree).

After reviewing your patches, it seems to me that the BKL isn't
needed in Squashfs.  You removed it from 23 filesystems because
it's not protecting any shared state,  on that basis it isn't needed
needed in Squashfs either.

Thanks

Phillip


