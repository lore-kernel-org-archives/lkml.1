Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYDYDm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYDYDm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYDYDmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:42:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbYDYDmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:42:18 -0400
Message-ID: <48115314.4090705@zytor.com>
Date: Thu, 24 Apr 2008 20:42:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 09/24] ia64: types: use <asm-generic/int-*.h> for the
 ia64 architecture
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <1209078352-7593-4-git-send-email-hpa@zytor.com> <1209078352-7593-5-git-send-email-hpa@zytor.com> <1209078352-7593-6-git-send-email-hpa@zytor.com> <1209078352-7593-7-git-send-email-hpa@zytor.com> <1209078352-7593-8-git-send-email-hpa@zytor.com> <1209078352-7593-9-git-send-email-hpa@zytor.com> <1209078352-7593-10-git-send-email-hpa@zytor.com> <1209078352-7593-11-git-send-email-hpa@zytor.com> <1209078352-7593-12-git-send-email-hpa@zytor.com> <1209078352-7593-13-git-send-email-hpa@zytor.com> <1209078352-7593-14-git-send-email-hpa@zytor.com> <1209078352-7593-15-git-send-email-hpa@zytor.com> <1209078352-7593-16-git-send-email-hpa@zytor.com> <1209078352-7593-17-git-send-email-hpa@zytor.com> <1209078352-7593-18-git-send-email-hpa@zytor.com> <1FE6DD409037234FAB833C420AA843EC012F9FDA@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC012F9FDA@orsmsx424.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> I get an error while building the ia64 sim_defconfig (which
> uses CONFIG_HZ=32)
> 
> kernel/time.c: In function `msecs_to_jiffies':
> kernel/time.c:472: error: `MSEC_TO_HZ_MUL32UL' undeclared (first use in this function)
> kernel/time.c:472: error: (Each undeclared identifier is reported only once
> kernel/time.c:472: error: for each function it appears in.)
> 
> 
> The generated timeconst.h has:
> #define MSEC_TO_HZ_MUL32        0x83126e98
> 
> So some weird cpp thing happened and the UL got concatenated
> before the MSEC_TO_HZ_MUL32 was swapped out for its defined
> value.
> 
> All the rest of the ia64 configs build ok.
> 

OK... I'm clearly having a bad day... not only is the last patch in the 
series (the kernel/time.c stuff) just plain broken, but I ran the wrong 
test battery on it.

I will fix it up and post a replacement patch.

	-hpa
