Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbYAOPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbYAOPsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYAOPsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:48:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60690 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYAOPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:48:12 -0500
Message-ID: <478CD46D.5080104@zytor.com>
Date: Tue, 15 Jan 2008 10:42:37 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86_64: check MSR to get MMCONFIG for AMD Family
 10h Opteron
References: <200801141331.45898.yinghai.lu@sun.com> <200801141335.15558.yinghai.lu@sun.com> <200801141336.35351.yinghai.lu@sun.com>
In-Reply-To: <200801141336.35351.yinghai.lu@sun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> +
> +	address = 0xc0010058;
> +	if (rdmsr_safe(address, &low, &high))
> +		return NULL;
> +

NAK.  Add the symbolic MSR name to asm-x86/msr-index.h and use the 
symbolic name in the code, please.

	-hpa
