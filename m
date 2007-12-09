Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbXLIWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbXLIWdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXLIWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:33:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51702 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXLIWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:33:23 -0500
Date: Sun, 9 Dec 2007 14:32:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-ID: <20071209143237.1e608d9f@laptopd505.fenrus.org>
In-Reply-To: <642708.11296.qm@web52902.mail.re2.yahoo.com>
References: <20071209133311.2db5ce4f@laptopd505.fenrus.org>
	<642708.11296.qm@web52902.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 22:06:21 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> --- Arjan van de Ven <arjan@infradead.org> wrote:
> > can you check if the attr_mem is properly ioremap'd ?
> > (probably with ioremap_nocache)
> 
> Can you elaborate, please? I am not familiar with these I/O
> primitives.

the memory you feed to readl() and co isnt the actual PCI resource;
you need to use ioremap() on the PCI resource to get a pointer that you can then feed to readl()....

> 
> > I wonder if there's anything else in that area as well..
> 
> So I should check /proc/iomem? But wouldn't Linux complain if two PCI
> devices conflicted as you're suggesting?

the other one might not be PCI..


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
