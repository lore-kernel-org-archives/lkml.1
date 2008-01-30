Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbYA3VXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbYA3VXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933124AbYA3VSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:18:50 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:10561 "EHLO
	outbound2-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933113AbYA3VSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:18:47 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47A0E9B2.1010706@am.sony.com>
Date: Wed, 30 Jan 2008 13:18:42 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Luck, Tony" <tony.luck@intel.com>, sparclinux@vger.kernel.org,
       linux-ia64@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86/non-x86: percpu, node ids, apic ids x86.git fixup
References: <200801301414.m0UEEgCC006371@hera.kernel.org>	<Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be>	<47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu>	<1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com>	<20080130180623.GA24881@elte.hu>	<1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <20080130184920.GA32212@elte.hu>
In-Reply-To: <20080130184920.GA32212@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2008 21:18:43.0211 (UTC) FILETIME=[B10A6DB0:01C86385]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Luck, Tony <tony.luck@intel.com> wrote:
> 
>> > Could you check the patch below? With this applied to latest -git, 
>> > ia64 buils fine for me in a cross-compiling environment. (but i dont 
>> > know whether it boots ...)
>> 
>> Uni-processor build still fails with this patch (config is 
>> arch/ia64/configs/tiger_defconfig with CONFIG_SMP switched from =y to 
>> =n).
> 
> could you try the full patchset that Travis has just sent and which i've 
> put into x86.git, you can pull it from:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> it's a fixes only tree, ontop of Linus-very-latest. Head 4b9e425c25f84. 
> [pull from ssh://master.kernel.org if it's not on git.kernel.org yet, 
> uploaded it this very minute.]

Just FYI, the following diff from the above tree applied to linux-2.6.git
works with ps3_defconfig on the PS3 (powerpc):

  git diff dd430ca20c40ecccd6954a7efd13d4398f507728..3823daf866c272c670dda7dc6179a647da64467f

-Geoff

