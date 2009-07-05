Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbZGESap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbZGESap (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZGESai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:30:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZGESah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:30:37 -0400
Message-ID: <4A50E323.6060109@zytor.com>
Date: Sun, 05 Jul 2009 10:30:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> 
>  How do you set cpu_has_apic for systems with discrete local APICs?  The 
> CPUID flag is not set in this case.
> 

Well, should it be?  We do set flags when they're appropriate to us, and
if the semantics are such as that is inappropriate we can set a custom bit.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

