Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbZHNUCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbZHNUCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbZHNUCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:02:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52913
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932218AbZHNUCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:02:49 -0400
Date: Fri, 14 Aug 2009 13:02:59 -0700 (PDT)
Message-Id: <20090814.130259.122634755.davem@davemloft.net>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma-debug: Allow archs to override
 check_for_illegal_area
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090812085440.GA14114@elte.hu>
References: <1250005381-17903-1-git-send-email-joerg.roedel@amd.com>
	<20090812085440.GA14114@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 12 Aug 2009 10:54:40 +0200

> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
>> For some architectures (like sparc32) the default 
>> check_for_illegal_area function does not work reliable. This patch 
>> makes this function a weak symbol allowing architectures to 
>> override it if necessary.
>> 
>> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>> ---
>>  lib/dma-debug.c |    9 ++++++---
>>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> Dave, you indicated that sparc32 would address this problem 
> differently. Do we still need this patch (for .31 for example)?

Don't worry about this purely for sparc32's sake.

We can revisit this patch if I can't sort out the sparc32 issue
locally.

Thanks.
