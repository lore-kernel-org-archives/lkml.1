Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbXKNTh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbXKNTh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762006AbXKNThs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:37:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763335AbXKNThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:37:47 -0500
Message-ID: <473B4D7F.5020708@zytor.com>
Date: Wed, 14 Nov 2007 11:33:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Add __discard section to x86
References: <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal> <473A4909.1020609@zytor.com> <20071114014445.GB19901@Krystal> <473A6471.4040700@zytor.com> <20071114185220.GA29533@Krystal> <473B45C4.5030501@zytor.com> <20071114191652.GA4438@Krystal>
In-Reply-To: <20071114191652.GA4438@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Add a __discard sectionto the linker script. Code produced in this section will
> not be put in the vmlinux file. This is useful when we have to calculate the
> size of an instruction before actually declaring it (for alignment purposes for
> instance). This is used by the immediate values.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Andi Kleen <ak@muc.de>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Chuck Ebbert <cebbert@redhat.com>
> CC: Christoph Hellwig <hch@infradead.org>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>

Acked-by: H. Peter Anvin <hpa@zytor.com>

