Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXLKQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXLKQiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLKQiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:38:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55884 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbXLKQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:38:09 -0500
Date: Tue, 11 Dec 2007 08:35:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: dor.laor@qumranet.com, tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
Message-ID: <20071211083513.56c2a385@laptopd505.fenrus.org>
In-Reply-To: <20071211142717.GA15903@elte.hu>
References: <475E8C8B.7070308@qumranet.com>
	<20071211133738.GA8150@elte.hu>
	<475E9A92.4030001@qumranet.com>
	<20071211142717.GA15903@elte.hu>
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

On Tue, 11 Dec 2007 15:27:17 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Dor Laor <dor.laor@gmail.com> wrote:
> 
> 
> The patch below should resolve this - could you please test and Ack
> it? But this CPUID was present in v2.6.23 too, so why did it only
> show up in 2.6.24-rc for you?

isn't this probably wrong since this code is also used in the vsyscall code..
