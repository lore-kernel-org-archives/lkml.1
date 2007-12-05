Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXLEDKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXLEDKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXLEDKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:10:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbXLEDKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:10:02 -0500
Date: Tue, 4 Dec 2007 19:09:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Message-Id: <20071204190923.f5037693.akpm@linux-foundation.org>
In-Reply-To: <4755BA14.8060706@grupopie.com>
References: <4755BA14.8060706@grupopie.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 20:35:32 +0000 Paulo Marques <pmarques@grupopie.com> wrote:

> When resolving symbol names from addresses with aliased symbol names, 
> kallsyms_lookup always returns the first symbol, even if it is a weak 
> symbol.
> 
> This patch changes this by sorting the symbols with the weak symbols 
> last before feeding them to the kernel. This way the kernel runtime 
> isn't changed at all, only the kallsyms build system is changed.
> 
> Another side effect is that the symbols get sorted by address, too. So, 
> even if future binutils version have some bug in "nm" that makes it fail 
> to correctly sort symbols by address, the kernel won't be affected by this.
> 
> 
> From: Paulo Marques <pmarques@grupopie.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

The signoffs don't make sense.

If you authored the patch then please put a From: at the top of the changelog
and include your signed-off-by:.

If Mathieu worked on or forwarded the patch then include his s-o-b.
If he wasn't in the delivery path but has tested/reviewed/approved the
patch then Acked-by: is more appropriate.  Documentation/SubmittingPatches
has details...
