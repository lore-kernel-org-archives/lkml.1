Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbYFPIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbYFPIbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYFPIbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:31:37 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44223 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143AbYFPIbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:31:36 -0400
Date: Mon, 16 Jun 2008 03:31:34 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, ying.huang@intel.com,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616033134.e18f9a6e.pj@sgi.com>
In-Reply-To: <86802c440806160034r343f9570ma0141df8af9360d7@mail.gmail.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806152354i24a1ec5ap316dacec0981d05@mail.gmail.com>
	<20080616023200.16eafc18.pj@sgi.com>
	<86802c440806160034r343f9570ma0141df8af9360d7@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> EFI memmap and ebda is partial overlapping?
> 
> you may expand range_in_ebda_area(), and let it handle overlapping...

Ok - now I understand your comment.

I hesitated at first to handle the overlapping case because it was
not clear to me how to handle it (and I didn't happen to need it ;).

I suppose that what I should do is reserve any additional range in the
memmap not already in the ebda reservation.

ugh ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
