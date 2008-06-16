Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYFPSFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYFPSFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYFPSFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:05:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59911 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751677AbYFPSFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:05:06 -0400
Date: Mon, 16 Jun 2008 13:05:03 -0500
From: Paul Jackson <pj@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       yhlu.kernel@gmail.com, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616130503.1a3a72dc.pj@sgi.com>
In-Reply-To: <4856A6F9.3090605@zytor.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
	<20080616032457.718f4d87.pj@sgi.com>
	<1213606435.12968.14.camel@caritas-dev.intel.com>
	<48568B56.7060307@zytor.com>
	<20080616113806.2ff4c1a4.pj@sgi.com>
	<48569D62.9050107@zytor.com>
	<20080616123721.bb9195e6.pj@sgi.com>
	<4856A6F9.3090605@zytor.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpa wrote:
> We *are* going to have similar hacks.  That's not a question.

I agree ;)  That's not the question.  I have no religious objection
to hacks.  I just try to keep their population in check.  In some
cases (PC BIOS and EFI come to mind ;) I am less successful than
in other cases.

> *Not* perpetuating may ... cause odd behaviours that only are
> noticeable when you, say, boot from one OS into another.

So I take it you are saying that the future permutations and, in this
case with nested boots, combinations are sufficiently diverse and
unpredictable that as a practical matter we should perpeturate this
(gentle) hack.

I'm fine with that.

Huang - would you agree to this safety reservation of the ebda area
even on EFI enabled systems?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
