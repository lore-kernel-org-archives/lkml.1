Return-Path: <linux-kernel-owner+w=401wt.eu-S1030948AbXDYPD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030948AbXDYPD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030958AbXDYPD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:03:26 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:59368 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030948AbXDYPDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:03:25 -0400
Message-ID: <462F6DB0.90801@namesys.com>
Date: Wed, 25 Apr 2007 19:03:12 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: lkml777@123mail.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Andi Kleen <andi@firstfloor.org>, Alex Zarochentsev <zam@namesys.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Eric Hopper <hopper@omnifarious.org>, Lex Lyamin <flx@msu.ru>,
       William Heimbigner <icxcnika@mar.tar.cc>,
       Rik van Riel <riel@redhat.com>, Xu CanHao <xucanhao@gmail.com>
Subject: Re: Question about Reiser4
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>   <462E17AF.7090604@namesys.com> <1177459922.31000.1186391425@webmail.messagingengine.com>
In-Reply-To: <1177459922.31000.1186391425@webmail.messagingengine.com>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lkml777@123mail.org wrote:

>
>As I understand it, the default Reiser4 DOES NOT USE any compression at
>all, not even tail compression,
>

^tail compression^tail conversion
Reiser4 does use tail conversion by default.

> but saves space by eliminating block
>alignment wastage (tail compression is an option).
>
>So lets LOSE the statistics that involve compression. The results now
>look like this:
>
>.-------------------------.
>| FILESYSTEM | TIME |DISK |
>| TYPE       |(secs)|USAGE|
>.-------------------------.
>|REISER4     | 3462 | 692 |
>|EXT2        | 4092 | 816 |
>|JFS         | 4225 | 806 |
>|EXT4        | 4408 | 816 |
>|EXT3        | 4421 | 816 |
>|XFS         | 4625 | 779 |
>|REISER3     | 6178 | 793 |
>|FAT32       |12342 | 988 |
>|NTFS-3g     |10414 | 772 |
>.-------------------------.
>
>These results are still EXTREMELY GOOD for REISER4.
>  
>

Everything is not so simple in the science of testing..
Would you please change direction of your activity to stressing
instead of benchmarking? Caught oopses would have great value..
OK?

Regards,
Edward.

