Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYFWJLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYFWJLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFWJLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:11:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:31147 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYFWJLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,689,1204531200"; 
   d="scan'208";a="1250837"
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
	via linked list of setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
In-Reply-To: <20080623034728.250c6fd1.pj@sgi.com>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	 <20080618114511.GB28838@elte.hu>
	 <1214200441.25753.5.camel@caritas-dev.intel.com>
	 <20080623015326.bec9a75d.pj@sgi.com>
	 <1214205686.26437.18.camel@caritas-dev.intel.com>
	 <20080623034728.250c6fd1.pj@sgi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Jun 2008 17:14:01 +0800
Message-Id: <1214212441.27182.4.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 23 Jun 2008 09:10:29.0812 (UTC) FILETIME=[FBA49740:01C8D510]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-23 at 03:47 -0500, Paul Jackson wrote:
> Huang Ying wrote:
> > So, I think it is better to remove "EFI memmap based code".
> 
> You give good reasons for -adding- E820 EXT code.  Fine.
> 
> You give no reason for -removing- the EFI memmap based code,
> except the implicit (unstated) reason that we should only
> support a single mechanism.
> 
> However the kernel routinely supports a variety of mechanisms
> for various BIOS firmware, as it should.
> 
> Internally, within the kernel, when it is entirely within the
> kernels control and when there is no externally visible kernel
> interface affected, we routinely strive to minimize redundant
> mechanisms, as we should.
> 
> But externally, such as in supporting various boot firmware
> protocols, we routinely support multiple useful interfaces.
> 
> If that EFI memmap based code for > 128 nodes is causing you
> no problem, then please leave it be.  It is providing us good
> benefit.

Please fix the following issue, if it is agreed to keep this redundant
code in kernel:

﻿4. Current EFI memmap based code does not work properly in all
situation, for example it can not works with kernel parameter:
"memmap=exactmap, memmap=<xxx>, ...", "mem=<xxx>" or "noefi".

Best Regards,
Huang Ying

