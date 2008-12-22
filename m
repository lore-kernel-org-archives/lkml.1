Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYLVMNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYLVMNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYLVMMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:12:53 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:57268 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYLVMMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:12:52 -0500
X-BigFish: VPS-51(z21eWz1432R62a3L98dR936eQ1805Mzzzz2f39iz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KCA1X0-01-ESL-01
Date: Mon, 22 Dec 2008 13:11:52 +0100
From: Robert Richter <robert.richter@amd.com>
To: Tim Blechmann <tim@klingt.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: 2.6.28-rc9: oprofile regression
Message-ID: <20081222121151.GX15411@erda.amd.com>
References: <1229869416.6911.1.camel@thinkpad> <1229894585.6898.6.camel@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1229894585.6898.6.camel@thinkpad>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Dec 2008 12:12:37.0837 (UTC) FILETIME=[946F5FD0:01C9642E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.08 22:23:05, Tim Blechmann wrote:
> > i am experiencing an issue, similar to the one reported in
> > http://lkml.org/lkml/2008/10/30/319.
> 
> bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> (oprofile: Implement Intel architectural perfmon support) caused the
> problem. 
> oddly, the newly introduced api is not used, since the model struct is
> set during the ppro_init call ...

Tim,

I just tested rc9 on a system I have available and I could not
reproduce this.

cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
stepping	: 2

Does fix 7c64ade53a6f977d73f16243865c42ceae999aea work on your system?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

