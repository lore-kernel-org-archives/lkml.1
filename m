Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXJMHgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXJMHgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbXJMHg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:36:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34189 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751967AbXJMHg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:36:27 -0400
Date: Sat, 13 Oct 2007 00:36:24 -0700
From: Paul Jackson <pj@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, willy@debian.org, fujita.tomonori@lab.ntt.co.jp,
       anil.s.keshavamurthy@intel.com, vs@namesys.com, edward@namesys.com,
       linux-kernel@vger.kernel.org
Subject: Re: git-block patches broken on 2.6.23-mm1 ia64 SN
Message-Id: <20071013003624.c11358a4.pj@sgi.com>
In-Reply-To: <20071013072504.GD969@kernel.dk>
References: <20071013001356.304b505f.pj@sgi.com>
	<20071013071821.GC969@kernel.dk>
	<20071013002003.2134542e.pj@sgi.com>
	<20071013072504.GD969@kernel.dk>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting with initcall_debug doesn't change the output at all.  If I
boot a working kernel with initcall_debug, the added output starts
showing up right after the point that my broken kernel is freezing.

    Mount-cache hash table entries: 1024
    ACPI: Core revision 20070126
    Boot processor id 0x0/0x0
    Brought up 8 CPUs
    Total of 8 processors activated (15564.80 BogoMIPS).
<< Broken kernel freezes here >>
<< Good kernel continues with ...>>
    Calling initcall 0xa0000001009d6310: net_ns_init+0x0/0x3e0()
    net_namespace: 120 bytes
    initcall 0xa0000001009d6310: net_ns_init+0x0/0x3e0() returned 0.
    initcall 0xa0000001009d6310 ran for 0 msecs: net_ns_init+0x0/0x3e0()
    Calling initcall 0xa0000001009d6630: run_dmi_scan+0x0/0x40()

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
