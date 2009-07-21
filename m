Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZGUDmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZGUDmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbZGUDmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:42:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42261 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbZGUDmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:42:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A6538EE.6000903@jp.fujitsu.com>
Date: Tue, 21 Jul 2009 12:41:34 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <andi@firstfloor.org>, Doug Thompson <norsk5@yahoo.com>,
       Borislav Petkov <borislav.petkov@amd.com>, mingo@elte.hu,
       tglx@linutronix.de, aris@redhat.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
References: <20090720180446.GB16072@basil.fritz.box> <935428.51568.qm@web50110.mail.re2.yahoo.com> <20090720192229.GC16072@basil.fritz.box> <4A64D0F2.7050009@zytor.com>
In-Reply-To: <4A64D0F2.7050009@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>  If you want modules to change the behavior, you're talking about a
> *dynamic* change -- the call will point to different things at different
> points in time -- so you need another mechanism, i.e. function pointers.

Just FYI, machine check handler on ia64 has such function pointer.

[arch/ia64/kernel/mca.c]
    826 /* Function pointer for extra MCA recovery */
    827 int (*ia64_mca_ucmc_extension)
    828         (void*,struct ia64_sal_os_state*)
    829         = NULL;


Thanks,
H.Seto

