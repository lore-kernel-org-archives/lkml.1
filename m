Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYFYUJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYFYUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYFYUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:09:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:46094 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYFYUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:09:21 -0400
Date: Wed, 25 Jun 2008 13:09:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Agner Fog <agner@agner.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080625130918.53ae744b@infradead.org>
In-Reply-To: <4862A25C.2060703@agner.org>
References: <48626514.2040905@agner.org>
	<20080625092224.736c2541@infradead.org>
	<4862A25C.2060703@agner.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008 21:54:04 +0200
Agner Fog <agner@agner.org> wrote:

> Arjan van de Ven wrote:
>  >Let me repeat this loud and clear:
>  >It is not allowed to use floating point, SSE of AVX in device
>  >drivers.
> 
> Thank you for a clear answer. Re-reading the ABI:
>  >A.2.4 Miscellaneous Remarks
>  >Linux Kernel code is not allowed to change the x87 and SSE units.
>  >If 
> those are
>  >changed by kernel code, they have to be restored properly before 
> sleeping or leaving
>  >the kernel. On preemptive kernels also more precautions may be
>  >needed.
> 
> This states your point, but certainly not "loud and clear" :-)
> 
> This ABI statement has to be amended, however, because it is allowed

the linux kernel policy is loud and clear; this is more an OS policy as
it is a platform ABI issue. We as linux do not allow this (with the
small footnote around the raid stuff, but that has specific very
careful use). In addition, you really aren't allowed to use floating
point in the kernel period as concept, if you need it you very likely
are doing something wrong.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
