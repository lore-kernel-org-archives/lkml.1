Return-Path: <linux-kernel-owner+w=401wt.eu-S1763609AbXIKSWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763609AbXIKSWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759239AbXIKSWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:22:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55116 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758302AbXIKSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:22:37 -0400
Date: Tue, 11 Sep 2007 20:22:14 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Do not deprecate binary semaphore or do allow mutex in software
 interrupt contexts
Message-ID: <20070911202214.5c3c28d2@laptopd505.fenrus.org>
In-Reply-To: <432622.65445.qm@web52004.mail.re2.yahoo.com>
References: <432622.65445.qm@web52004.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 10:29:19 -0700 (PDT)
Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

> > Not being too familiar with the timer stuff, it smells wrong what
> > you say.
> 
> Why?

timers and sleeping locks really shouldn't be mixed.
It ends up in general as more complex, fragile and weird...

But feel free to prove us otherwise with real code...
