Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYFWIrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYFWIrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYFWIrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:47:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42098 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752569AbYFWIrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:47:31 -0400
Date: Mon, 23 Jun 2008 03:47:28 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
 via linked list of setup data
Message-Id: <20080623034728.250c6fd1.pj@sgi.com>
In-Reply-To: <1214205686.26437.18.camel@caritas-dev.intel.com>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	<20080618114511.GB28838@elte.hu>
	<1214200441.25753.5.camel@caritas-dev.intel.com>
	<20080623015326.bec9a75d.pj@sgi.com>
	<1214205686.26437.18.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> So, I think it is better to remove "EFI memmap based code".

You give good reasons for -adding- E820 EXT code.  Fine.

You give no reason for -removing- the EFI memmap based code,
except the implicit (unstated) reason that we should only
support a single mechanism.

However the kernel routinely supports a variety of mechanisms
for various BIOS firmware, as it should.

Internally, within the kernel, when it is entirely within the
kernels control and when there is no externally visible kernel
interface affected, we routinely strive to minimize redundant
mechanisms, as we should.

But externally, such as in supporting various boot firmware
protocols, we routinely support multiple useful interfaces.

If that EFI memmap based code for > 128 nodes is causing you
no problem, then please leave it be.  It is providing us good
benefit.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
