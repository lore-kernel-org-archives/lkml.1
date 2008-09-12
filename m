Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbYILNfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbYILNfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 09:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYILNfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 09:35:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYILNfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:35:41 -0400
Date: Fri, 12 Sep 2008 06:35:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to
 microcode_intel.c.
Message-ID: <20080912063517.783b7f85@infradead.org>
In-Reply-To: <48CA586C.2010104@amd.com>
References: <20080728164411.490752571@amd.com>
	<20080728164448.492961653@amd.com>
	<20080907120823.59f8fa47@infradead.org>
	<48CA586C.2010104@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 13:54:20 +0200
Peter Oruba <peter.oruba@amd.com> wrote:

> Arjan,
> 
> could you please provide some more information about that issue?

well.. the fedora boot script just plain fails.
I suspect it manually loads microcode.ko or something if CPUID says
intel; and this now stops working...
