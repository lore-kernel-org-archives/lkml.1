Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXJ2XT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXJ2XT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJ2XTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:19:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52084 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbXJ2XTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:19:50 -0400
Date: Mon, 29 Oct 2007 16:15:34 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: vgoyal@in.ibm.com, tglx@linutronix.de, hbabu@us.ibm.com,
       linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Revert x86: add lapic_shutdown for x86_64
Message-ID: <20071029161534.6e7f0db6@laptopd505.fenrus.org>
In-Reply-To: <47266132.5050001@ct.jp.nec.com>
References: <47195763.1090803@ct.jp.nec.com>
	<47195807.6030809@ct.jp.nec.com>
	<20071024062933.GA4622@in.ibm.com>
	<47266132.5050001@ct.jp.nec.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 15:39:46 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> lapic_shutdown is useless on x86_64.
> 

.... but since the goal is to get apic_32.c and apic_64.c to be more
converging (to the point of becoming the same file)... isn't your patch
going in the opposite direction?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
