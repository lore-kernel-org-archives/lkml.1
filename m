Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0BARZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:25:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1694 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab0BARZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:25:40 -0500
Subject: Re: [PATCH 1/9] bitops: rename for_each_bit to for_each_set_bit
From: Joe Perches <joe@perches.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 09:25:39 -0800
Message-ID: <1265045139.25140.284.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 00:10 +0900, Akinobu Mita wrote:
> Rename for_each_bit to for_each_set_bit in the kernel source tree.

I preferred the for_each_bit because it gives some
naming consistency.

These look for set bits:

        find_first_bit
        find_next_bit
        find_last_bit
        
These look for unset bits:

        find_first_zero_bit
        find_next_zero_bit

I think there should be 3 macros named:
        for_each_bit
        for_each_zero_bit
        for_every_bit

and maybe there's a use for:
        find_last_zero_bit

I think the macro definition should be located
near these other functions in bitops.h and not
placed somewhat randomly near the top of the file.


