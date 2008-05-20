Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbYETOrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbYETOrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765911AbYETOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:47:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765725AbYETOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:47:40 -0400
Message-ID: <4832E461.2070503@zytor.com>
Date: Tue, 20 May 2008 07:46:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Remove unnecessary code in 64bit CPU identification.
References: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org>
In-Reply-To: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> There were no 64bit Transmeta CPUs made (and it'd be something of
> a surprise if they started any time soon).   To the best of my knowledge,
> no CPU vendor cloned the 80860000 cpuid space claimed by Transmeta.
> By removing this code, we can also eliminate calling cpuid 0x80000007 twice.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

I'd really like to avoid divergences between the 32-bit and 64-bit code 
if they can be avoided at this point.  These codes need to be unified, 
not further split.

	-hpa
