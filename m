Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZHXRaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZHXRaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZHXRaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:30:55 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:59635 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZHXRay convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:30:54 -0400
MIME-Version: 1.0
In-Reply-To: <20090824090121.61c6f0ea.randy.dunlap@oracle.com>
References: <200908241007.33844.ngupta@vflare.org>
	 <20090824090121.61c6f0ea.randy.dunlap@oracle.com>
Date: Mon, 24 Aug 2009 23:00:55 +0530
Message-ID: <d760cf2d0908241030u6efdd816i2bafdf0a0368e34@mail.gmail.com>
Subject: Re: [PATCH 0/4] compcache: compressed in-memory swapping
From: Nitin Gupta <ngupta@vflare.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 9:31 PM, Randy Dunlap<randy.dunlap@oracle.com> wrote:
> On Mon, 24 Aug 2009 10:07:33 +0530 Nitin Gupta wrote:
>
>> (Sorry for long patch[2/4] but its now very hard to split it up).
>>
>>  Documentation/blockdev/00-INDEX       |    2 +
>>  Documentation/blockdev/ramzswap.txt   |   52 ++
>>  drivers/block/Kconfig                 |   22 +
>>  drivers/block/Makefile                |    1 +
>>  drivers/block/ramzswap/Makefile       |    2 +
>
> I can't find drivers/block/ramzswap/Makefile in the patches...
>

My bad. I missed it. Here it is:

obj-$(CONFIG_BLK_DEV_RAMZSWAP)  +=      ramzswap.o xvmalloc.o


I will send updated diffs with swap_lock fix in patch[3/4] with this Makefile
include once I get additional reviews.

Thanks,
Nitin
