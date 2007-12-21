Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbXLUDTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbXLUDTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 22:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXLUDTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 22:19:09 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:50556 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754371AbXLUDTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 22:19:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAPq+akdMROHU/2dsb2JhbACBV6cC
Date: Thu, 20 Dec 2007 22:19:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 14/24] Immediate Values - x86 Optimization
Message-ID: <20071221031900.GA2414@Krystal>
References: <20071221015438.433195466@polymtl.ca> <20071221015726.909058404@polymtl.ca> <476B2B5E.5060204@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <476B2B5E.5060204@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:11:15 up 47 days,  8:16,  3 users,  load average: 0.67, 0.89,
	0.76
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> This patch is modified by another patch in the sequence.  This feels 
> needlessly confusing when reviewing (especially since the comment doesn't 
> look to match the code, e.g. w.r.t to "Q" and "R" constraints); can you 
> reorder the patchset to avoid that?
>

Argh.. Rusty asked to have a simplified version first, and then to
implement the "more complex" one on top of it. However, in order to get
the reentrancy I need for the markers, I need the complex version of the
immediate values. Therefore, you find, in this patchset, the simple
version first, and then, the more complex one implemented on top.

About this patch header, the initial idea was to use the "Q" and "R"
constraints, but, as stated just below, the "q" and "r" constraints are
used instead to make sure the REX prefixed opcodes for 1, 2, and 4 bytes
immediate values are never used. So the complete header follows the
source code, it's just that this paragraph could be clearer.

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
