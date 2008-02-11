Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYBKPNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYBKPNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYBKPNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:13:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33610 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbYBKPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:13:24 -0500
Date: Mon, 11 Feb 2008 07:12:37 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
Message-ID: <20080211071237.36324cb2@laptopd505.fenrus.org>
In-Reply-To: <20080211093434.E30961B41CE@basil.firstfloor.org>
References: <200802111034.764275766@suse.de>
	<20080211093434.E30961B41CE@basil.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 10:34:34 +0100 (CET)
Andi Kleen <ak@suse.de> wrote:

> 
> When end_pfn is not aligned to 2MB (or 1GB) then the kernel might
> map more memory than end_pfn. Account this in end_pfn_mapped.

we need to fix this btw; mapping memory that doesn't really exist
is a rather nasty trap with cpu prefetching and the like.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
