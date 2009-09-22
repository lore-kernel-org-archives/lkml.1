Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbZIVIgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbZIVIgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbZIVIgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:36:10 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:52439 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbZIVIgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:36:09 -0400
MIME-Version: 1.0
In-Reply-To: <1253600030.30406.2.camel@penberg-laptop>
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
	 <1253600030.30406.2.camel@penberg-laptop>
Date: Tue, 22 Sep 2009 14:06:12 +0530
Message-ID: <d760cf2d0909220136g38c0541bxab93f9b5a2b22d7@mail.gmail.com>
Subject: Re: [PATCH 0/3] compcache: in-memory compressed swapping v4
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 11:43 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Tue, 2009-09-22 at 10:26 +0530, Nitin Gupta wrote:
>>  drivers/staging/Kconfig                   |    2 +
>>  drivers/staging/Makefile                  |    1 +
>>  drivers/staging/ramzswap/Kconfig          |   21 +
>>  drivers/staging/ramzswap/Makefile         |    3 +
>>  drivers/staging/ramzswap/ramzswap.txt     |   51 +
>>  drivers/staging/ramzswap/ramzswap_drv.c   | 1462 +++++++++++++++++++++++++++++
>>  drivers/staging/ramzswap/ramzswap_drv.h   |  173 ++++
>>  drivers/staging/ramzswap/ramzswap_ioctl.h |   50 +
>>  drivers/staging/ramzswap/xvmalloc.c       |  533 +++++++++++
>>  drivers/staging/ramzswap/xvmalloc.h       |   30 +
>>  drivers/staging/ramzswap/xvmalloc_int.h   |   86 ++
>>  include/linux/swap.h                      |    5 +
>>  mm/swapfile.c                             |   34 +
>>  13 files changed, 2451 insertions(+), 0 deletions(-)
>
> This diffstat is not up to date, I think.
>

Oh! this is from v3. I forgot to update it. I don't have access to my git tree
here in office, so cannot send updated version right now.

> Greg, would you mind taking this driver into staging? There are some
> issues that need to be ironed out for it to be merged to kernel proper
> but I think it would benefit from being exposed to mainline.
>
> Nitin, you probably should also submit a patch that adds a TODO file
> similar to other staging drivers to remind us that swap notifiers and
> the CONFIG_ARM thing need to be resolved.
>

ok, I will send patch for TODO file.

Thanks,
Nitin
