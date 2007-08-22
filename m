Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbXHVQ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbXHVQ2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933002AbXHVQ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:28:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49404 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764733AbXHVQ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:28:41 -0400
Message-ID: <46CC6420.2030506@zytor.com>
Date: Wed, 22 Aug 2007 09:28:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Andi Kleen <ak@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1187313920.28497.1.camel@caritas-dev.intel.com>	 <1187580031.27947.67.camel@caritas-dev.intel.com>	 <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>	 <46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>	 <86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>	 <20070822012216.GN32640@bingen.suse.de>	 <86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>	 <20070822111155.GP32640@bingen.suse.de> <851fc09e0708220723v5fcb2fc5n4993c6f859c28b83@mail.gmail.com>
In-Reply-To: <851fc09e0708220723v5fcb2fc5n4993c6f859c28b83@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> 
> My proposal: Use Peter proposed "linked list of struct setup_data"
> style boot protocol as long term goal.
> 
> To smooth the transforming process, the following back compatible
> scheme can be taken:
> 
> 1. Keep zero page as an informal external boot protocol, and marked it
> as deprecated for external usage.
> 2. Add a magic number to standard boot protocol, which is set by
> bootloader to indicate the new style or old style boot protocol is
> used.
> 3. Add the pointer to "linked list of struct setup_data" to standard
> boot protocol.
> 4. If kernel is booted with correct magic number, the kernel will
> convert "linked list" to zero page, or use "linked list" directly. If
> kernel is booted with incorrect magic number, the kernel will use the
> "zero page" from bootloader or convert "zero page" to "linked list".
> 

You're making it needlessly complicated.

	-hpa
