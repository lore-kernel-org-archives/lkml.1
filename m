Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZFEWFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZFEWFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZFEWFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:05:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37100 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752275AbZFEWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:05:34 -0400
Date: Fri, 5 Jun 2009 23:06:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@morethan.org, linux-kernel@vger.kernel.org
Subject: Re: [Compile Warning] 2.6.30-rc8 build
Message-ID: <20090605230641.2b3013c4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090605145756.ed566f48.akpm@linux-foundation.org>
References: <200906051143.06119.lkml@morethan.org>
	<20090605190138.5ac32f94@lxorguk.ukuu.org.uk>
	<20090605145756.ed566f48.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't think there's any way in which gcc can deduce that h->first is
> non-zero on entry to that loop.  Even if it inlines
> serial_unlink_irq_chain() into serial8250_shutdown().

Why does it care ?

Suppose the list is empty, n is loaded with NULL

That follows the BUG_ON path which expands to include a function marked
as not returning

gcc is just rather smarter than your average cc



