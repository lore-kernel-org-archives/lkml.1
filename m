Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbZKFT0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbZKFT0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759271AbZKFT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:26:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39803 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbZKFT0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:26:13 -0500
Message-ID: <4AF4784C.5090800@zytor.com>
Date: Fri, 06 Nov 2009 11:26:04 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: ling.ma@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com>
In-Reply-To: <4AF457E0.4040107@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2009 09:07 AM, H. Peter Anvin wrote:
> 
> Where did the 1024 byte threshold come from?  It seems a bit high to me,
> and is at the very best a CPU-specific tuning factor.
> 
> Andi is of course correct that older CPUs might suffer (sadly enough),
> which is why we'd at the very least need some idea of what the
> performance impact on those older CPUs would look like -- at that point
> we can make a decision to just unconditionally do the rep movs or
> consider some system where we point at different implementations for
> different processors -- memcpy is probably one of the very few
> operations for which something like that would make sense.
> 

To be expicit: Ling, would you be willing to run some benchmarks across
processors to see how this performs on non-Nehalem CPUs?

	-hpa
