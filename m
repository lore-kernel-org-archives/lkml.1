Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbXLUDiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbXLUDiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXLUDim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:38:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34987 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXLUDil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:38:41 -0500
Message-ID: <476B335C.5080905@zytor.com>
Date: Thu, 20 Dec 2007 19:30:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 14/24] Immediate Values - x86 Optimization
References: <20071221015438.433195466@polymtl.ca> <20071221015726.909058404@polymtl.ca> <476B2B5E.5060204@zytor.com> <20071221031900.GA2414@Krystal>
In-Reply-To: <20071221031900.GA2414@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Argh.. Rusty asked to have a simplified version first, and then to
> implement the "more complex" one on top of it. However, in order to get
> the reentrancy I need for the markers, I need the complex version of the
> immediate values. Therefore, you find, in this patchset, the simple
> version first, and then, the more complex one implemented on top.
> 
> About this patch header, the initial idea was to use the "Q" and "R"
> constraints, but, as stated just below, the "q" and "r" constraints are
> used instead to make sure the REX prefixed opcodes for 1, 2, and 4 bytes
> immediate values are never used. So the complete header follows the
> source code, it's just that this paragraph could be clearer.
> 

Then you have it backwards.  "Q" and "R" avoid REX prefixes, "q" and "r" 
DO NOT.

	-hpa
