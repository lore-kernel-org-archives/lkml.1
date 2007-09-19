Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXISJ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXISJ13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbXISJ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:27:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49445 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753396AbXISJ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:27:21 -0400
Date: Wed, 19 Sep 2007 10:34:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2 2/2] i386/x86_64 boot: document for 32 bit boot
 protocol
Message-ID: <20070919103432.49ab7dc0@the-village.bc.nu>
In-Reply-To: <1190171428.12429.63.camel@caritas-dev.intel.com>
References: <1190171428.12429.63.camel@caritas-dev.intel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 11:10:28 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> This patch defines a 32-bit boot protocol and adds corresponding
> document. It is based on the proposal of Peter Anvin.
> 
> 
> Known issues:
> 
> - The hd0_info and hd1_info are deleted from the zero page. Additional
>   work should be done for this? Or this is unnecessary (because no new
>   fields will be added to zero page)?

They aren't actually that useful as for pretty much any 386 or later PC
we can recover the disk geometry via the BIOS tables, or via EDD. Right
now we don't save some neccessary fields if using EDD 1.1 but they could
be saved into the same place EDD 3.0 puts them.

