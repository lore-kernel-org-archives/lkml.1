Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbYBEVvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbYBEVvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYBEVuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:50:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51349 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513AbYBEVuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:50:54 -0500
Date: Tue, 5 Feb 2008 13:50:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] x86: add code to dump the (kernel) page tables for
 visual inspection
Message-ID: <20080205135030.30ea97a9@laptopd505.fenrus.org>
In-Reply-To: <47A8CB3C.1090101@cosmosbay.com>
References: <20080204222641.4488e6a7@laptopd505.fenrus.org>
	<47A8CB3C.1090101@cosmosbay.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 21:46:52 +0100
Eric Dumazet <dada1@cosmosbay.com> wrote:

> Arjan van de Ven a écrit :
> > Subject: x86: add code to dump the (kernel) page tables for visual
> > inspection by kernel developers From: Arjan van de Ven
> > <arjan@linux.intel.com>
> > 
> > This patch adds code to the kernel to have an (optional)
> > /proc/kernel_page_tables debug file that basically dumps the kernel
> > pagetables; this allows us kernel developers to verify that nothing
> > fishy is going on and that the various mappings are set up
> > correctly. This was quite useful in finding various
> > change_page_attr() bugs, and is very likely to be useful in the
> > future as well.
> > 
> 
> Seems nice Arjan, but could we also add NUMA information ?
> 


ok maybe I'm missing something, but the kernel VA space currently
is totally not numa dependent in any shape or form... 
so can you explain what kind of information you're looking for?
(I guess I just don't really understand your request; can you expand a bit on it?)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
