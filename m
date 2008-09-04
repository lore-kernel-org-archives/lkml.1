Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYIDA1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYIDA1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 20:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYIDA0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 20:26:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:46727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbYIDA0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 20:26:53 -0400
Message-ID: <48BF2AEB.1050508@kernel.org>
Date: Thu, 04 Sep 2008 02:25:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regarding major number of block extended devt
References: <48BD30F9.6080108@kernel.org> <48BD3313.7090906@kernel.org> <48BD9F36.8000704@zytor.com> <48BE0EDB.20107@kernel.org> <48BEB759.4050503@zytor.com> <48BEB98C.8030303@kernel.org> <48BEBAF0.7070008@zytor.com> <48BEBF34.50006@kernel.org> <48BED351.1060300@zytor.com>
In-Reply-To: <48BED351.1060300@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 04 Sep 2008 00:26:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin wrote:
> Thinking about it some more, one invariant this is *guaranteed* to
> violate is:
> 
>     partition_number = partition_device - master_device
> 
> Code that needs a partition number (which is common enough) are using
> this invariant, because (a) it has held for 17 years and (b) because
> there is still no alternative other that relying on fragile naming
> scheme hacks.
> 
> (a) we can't do anything about, but (b) we can, by introducing a
> partition number attribute in sysfs.

Yeah, that would certainly be a nice addition.  Also, if partitions
are made proper classes, they'll be easily enumerable by
/sys/block/*/partitions/*.

Jens, what do you think?

-- 
tejun
