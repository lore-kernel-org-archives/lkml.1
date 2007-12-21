Return-Path: <linux-kernel-owner+w=401wt.eu-S1765066AbXLUDFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765066AbXLUDFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXLUDEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:04:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbXLUDEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:04:54 -0500
Message-ID: <476B2B5E.5060204@zytor.com>
Date: Thu, 20 Dec 2007 18:56:30 -0800
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
References: <20071221015438.433195466@polymtl.ca> <20071221015726.909058404@polymtl.ca>
In-Reply-To: <20071221015726.909058404@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is modified by another patch in the sequence.  This feels 
needlessly confusing when reviewing (especially since the comment 
doesn't look to match the code, e.g. w.r.t to "Q" and "R" constraints); 
can you reorder the patchset to avoid that?

	-hpa
