Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbXKMWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbXKMWWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbXKMWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:22:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44600 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844AbXKMWWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:22:24 -0500
Date: Tue, 13 Nov 2007 22:22:12 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tobias Powalowski <t.powa@gmx.de>, linux-kernel@vger.kernel.org,
       Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/paravirt: revert exports to restore old behaviour
Message-ID: <20071113222212.GA1322@infradead.org>
References: <200711131139.42791.t.powa@gmx.de> <473A073C.2020201@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473A073C.2020201@goop.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 12:21:16PM -0800, Jeremy Fitzhardinge wrote:
> Subject: x86/paravirt: revert exports to restore old behaviour
> 
> Subdividing the paravirt_ops structure caused a regression in certain
> non-GPL modules which try to use mmu_ops and cpu_ops.  This restores
> the old behaviour, and makes it consistent with the
> non-CONFIG_PARAVIRT case.

NACK, both of these are internal and graphics drivers should not be
using them.

