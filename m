Return-Path: <linux-kernel-owner+w=401wt.eu-S1752066AbYIBMhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbYIBMhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYIBMhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:37:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:39909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYIBMhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:37:00 -0400
Message-ID: <48BD3313.7090906@kernel.org>
Date: Tue, 02 Sep 2008 14:35:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org>
In-Reply-To: <48BD30F9.6080108@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 12:36:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Extended devt is scheduled for 2.6.28 merge and is currently using 259.
> Can extended devt keep this major or should it use something else?

Oops, I forgot to write information about ext devt.

 259 block	Block extended device numbers

		This is pool of dynamically allocated block device
		numbers.  Currently, ide and sd overflows into this
		region if there are more partitions than the existing
		device number scheme can accomodate, but any block
		device can use it and it's not restricted to
		overflows.

Thanks.

-- 
tejun
