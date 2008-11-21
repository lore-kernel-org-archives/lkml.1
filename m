Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYKURHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYKURHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYKURHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:07:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbYKURHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:07:03 -0500
Subject: Re: [PATCH 0/10] DMA-API debugging facility
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081121165722.GD1386@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
	 <1227286492.4901.208.camel@macbook.infradead.org>
	 <20081121165722.GD1386@amd.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 17:06:55 +0000
Message-Id: <1227287215.4901.213.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 17:57 +0100, Joerg Roedel wrote:
> Yes, in principle we could move most of it to generic code. There is
> nothing architecture specific in it.
> Anybody who prefers this to be arch/x86 before moving it to lib/?

I think it's better to start off with a generic version, and test it on
more than one architecture before feeding it upstream. That way, you
know you aren't going to have to go back to the drawing board with it.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

