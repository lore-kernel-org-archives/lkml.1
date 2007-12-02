Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbXLBAxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbXLBAxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXLBAxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:53:24 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:51308 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXLBAxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:53:23 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Dec 2007 19:53:23 EST
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Date: Sun, 2 Dec 2007 01:54:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071201092037.GA32544@elte.hu> <alpine.DEB.0.9999.0712011036340.10996@chino.kir.corp.google.com> <20071201193643.GA10911@elte.hu>
In-Reply-To: <20071201193643.GA10911@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712020155.00187.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007, Ingo Molnar wrote:
> maybe, but we'd have to see how often this gets triggered. An OOM is 
> something that could happen in any overloaded system - while a hung task 
> is likely due to a kernel bug.

What about a client using hard mounted NFS shares here? That shouldn't be
killed by the OOM killer in that situation, should it?

Am I missing sth.?


Best Regards

Ingo Oeser
