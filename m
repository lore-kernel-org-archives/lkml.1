Return-Path: <linux-kernel-owner+w=401wt.eu-S935551AbXGLQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551AbXGLQpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXGLQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:45:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:35827 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752769AbXGLQpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:45:35 -0400
Message-ID: <46965B28.7000703@ru.mvista.com>
Date: Thu, 12 Jul 2007 20:47:36 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: mingo@elte.hu, tglx@linutronix.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, dwalker@mvista.com
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: revert fix for threaded fasteoi IRQ
 handlers
References: <200611192243.34850.sshtylyov@ru.mvista.com> <200705171719.34968.sshtylyov@ru.mvista.com>
In-Reply-To: <200705171719.34968.sshtylyov@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

> Revert the change to the "fasteoi" type chips as after handle_fasteoi_irq() had
> been fixed, they've become meaningless (and even dangerous -- as was the case
> with Celleb that has been fixed earlier)...

> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> ---
> The patch in question wasn't even initially accepted but then was erroneously
> restored along with the TOD patch.  I've asked to revert it but to no avail,
> so here's the formal patch to revert it at last...

    Now that the -rt patch has been first release in the broken-out version, 
let me tell you that the following 3 patches in the series can be just 
annihilated:

preempt-irqs-ppc-ack-irq-fixups.patch
preempt-irqs-ppc-fix-b5.patch
preempt-irqs-ppc-fix-more-fasteoi.patch

as all that the latter two are doing is undoing the former one.

WBR, Sergei
