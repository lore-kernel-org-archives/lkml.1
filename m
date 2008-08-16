Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYHPRrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYHPRrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYHPRro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:47:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:35787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYHPRrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:47:43 -0400
Date: Sat, 16 Aug 2008 10:47:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <cborntra@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking
 waiting
Message-ID: <20080816104729.036fa748@infradead.org>
In-Reply-To: <48A70185.2020600@goop.org>
References: <48A70185.2020600@goop.org>
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

On Sat, 16 Aug 2008 09:34:13 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> 
> The trigger API is simple:
> 
> To initialize a trigger, you can either do it statically with:

it looks a lot like a spinning completion ;-)

can we make it more simple by just having spinning versions of the wait
for completion functions?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
