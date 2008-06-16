Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYFPSJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYFPSJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYFPSJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:09:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59583 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754214AbYFPSJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:09:42 -0400
Date: Mon, 16 Jun 2008 13:09:38 -0500
From: Paul Jackson <pj@sgi.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: hpa@zytor.com, ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       steiner@sgi.com, travis@sgi.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/8] x86 boot: allow overlapping ebda and efi memmap
 memory ranges
Message-Id: <20080616130938.527283f7.pj@sgi.com>
In-Reply-To: <86802c440806161041v5f582d4y2a65adf57451a6d9@mail.gmail.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
	<20080616063001.14597.96170.sendpatchset@polaris-admin.engr.sgi.com>
	<1213600062.11185.13.camel@caritas-dev.intel.com>
	<20080616032457.718f4d87.pj@sgi.com>
	<1213606435.12968.14.camel@caritas-dev.intel.com>
	<48568B56.7060307@zytor.com>
	<20080616113806.2ff4c1a4.pj@sgi.com>
	<48569D62.9050107@zytor.com>
	<20080616123721.bb9195e6.pj@sgi.com>
	<86802c440806161041v5f582d4y2a65adf57451a6d9@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai wrote:
> like to see to make reserve_ebda_region() more smart like the old
> way when andi introduced ebda_size... instead of reserve 0x9000 to
> 0x100000 all the way.

Looking back at some older kernels, that code seems to have setup an
ebda region only if there was a non-zero real mode pointer at 0x40E.

This is rather different than always setting up such a region.

I would hesitate myself to re-introduce that code, because I know
too little, and have no pressing need for it.

I will leave to others the desirability of such a change.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
