Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbXJKNun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbXJKNun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXJKNuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:50:35 -0400
Received: from smile.2scale.net ([212.12.33.142]:6599 "EHLO smile.2scale.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbXJKNue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:50:34 -0400
Subject: Re: howto boost write(2) performance?
From: Michael Stiller <ms@2scale.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p73odf849rq.fsf@bingen.suse.de>
References: <1191937817.3641.9.camel@blackberry>
	 <p73odf849rq.fsf@bingen.suse.de>
Content-Type: text/plain
Organization: 2scale GmbH
Date: Thu, 11 Oct 2007 15:50:17 +0200
Message-Id: <1192110617.3696.2.camel@blackberry>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 16:56 +0200, Andi Kleen wrote:
> Michael Stiller <ms@2scale.net> writes:
> > 
> > The write(2) performance is not good enough, the writer threads take to
> > much time, and i ask you for ideas, howto to boost the write
> > performance. 
> 
> You could use an O_DIRECT write if the data is suitably aligned
> and your IO sizes are big enough (O_DIRECT is usually a loss
> on small IOs). It will also be synchronous, but if you do it 
> from a separate thread anyways that should be fine.

Thanks to all who answered and especially to Andi. Using O_DIRECT did
the trick.

Cheers,

Michael


