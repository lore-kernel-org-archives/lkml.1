Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYFWJsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYFWJsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 05:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbYFWJsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 05:48:17 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60769 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757075AbYFWJsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:48:16 -0400
Date: Mon, 23 Jun 2008 04:48:13 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
 via linked list of setup data
Message-Id: <20080623044813.d2fee3a0.pj@sgi.com>
In-Reply-To: <1214212441.27182.4.camel@caritas-dev.intel.com>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
	<20080618114511.GB28838@elte.hu>
	<1214200441.25753.5.camel@caritas-dev.intel.com>
	<20080623015326.bec9a75d.pj@sgi.com>
	<1214205686.26437.18.camel@caritas-dev.intel.com>
	<20080623034728.250c6fd1.pj@sgi.com>
	<1214212441.27182.4.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> 4. Current EFI memmap based code does not work properly in all
> situation, for example it can not works with kernel parameter:
> "memmap=exactmap, memmap=<xxx>, ...", "mem=<xxx>" or "noefi".

With "noefi" parameter, my EFI memmap based code is not supposed
to do anything.  The "noefi" parameter asks the kernel to ignore
any EFI support in the firmware it is booting from.

Could you tell me more what you mean by "does not work properly?"

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
