Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYFPQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYFPQiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYFPQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:38:10 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36038 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753984AbYFPQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:38:09 -0400
Date: Mon, 16 Jun 2008 11:38:06 -0500
From: Paul Jackson <pj@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616113806.2ff4c1a4.pj@sgi.com>
In-Reply-To: <48568B56.7060307@zytor.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
	<20080616032457.718f4d87.pj@sgi.com>
	<1213606435.12968.14.camel@caritas-dev.intel.com>
	<48568B56.7060307@zytor.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa wrote:
> Realistically, we need the infrastructure to be able to make paranoia 
> reservations, and you need to be able to deal with later finding they 
> are actually in use.

While the tone of your reply sounds like something I would naturally
agree with, I can't actually figure out what you mean in this case ;).

In particular, Peter, would you agree/disagree/other with the direction
that Huang and I agreed to last night:

> Would you recommend doing this with code in arch/x86/kernel/head.c,
> that did not invoke reserve_ebda_region() if efi_enabled was set?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
