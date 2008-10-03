Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYJCRWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYJCRWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbYJCRVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:21:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYJCRVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:21:38 -0400
Date: Fri, 3 Oct 2008 10:21:17 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081003102117.7db22b09@infradead.org>
In-Reply-To: <20081002222438.8f9f90a2.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
	<20081002212355.621a4fb6@infradead.org>
	<20081002214000.89420bb3.akpm@linux-foundation.org>
	<20081002214353.30873f98@infradead.org>
	<20081002215026.a63ba0d0.akpm@linux-foundation.org>
	<20081002220040.7963596c@infradead.org>
	<20081002222438.8f9f90a2.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 22:24:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Mount a junk partition with `-oakpm' and run some benchmarks.  If the
> results are "wow" then it's worth spending time on.  If the results
> are "meh" then we can not bother..
> 

I've been running with this for a few hours now
while I can't see IO is perfectly smooth now, it does feel a lot better
and latencytop isn't showing me the huge spikes in latency either in
the mail client.
(there's a lot of little stuff, but not the 4+ seconds)
-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
