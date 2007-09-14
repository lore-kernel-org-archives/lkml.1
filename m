Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXINGTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXINGTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 02:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXINGTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 02:19:10 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:33359 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXINGTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 02:19:09 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix race with shared tag queue maps
Date: Fri, 14 Sep 2007 08:19:00 +0200
User-Agent: PLD Linux KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       orgis@agnld.uni-potsdam.de, ed.lin@promise.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James.Bottomley@steeleye.com
References: <20070913122652.GK25592@kernel.dk>
In-Reply-To: <20070913122652.GK25592@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709140819.00741.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 of September 2007, Jens Axboe wrote:
> Hi,
>
> There's a race condition in blk_queue_end_tag() for shared tag maps,
> users include stex (promise supertrak thingy) and qla2xxx.
[...]
> I'm cc'ing users that reported stex 
> problems, hopefully they can test this patch and report back.

I'm running 2.6.22 with f3da54ba140c6427fa4a32913e1bf406f41b5dda patch from 
Linus git tree (instead of Ed Lin workaround patch) and doing heavy rsync for 
last 8 hours. No oops - seems to be working fine (+stex driver).

Thanks!

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
