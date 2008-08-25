Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYHYEAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYHYEAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 00:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbYHYEAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 00:00:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYHYEAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 00:00:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking waiting
Date: Mon, 25 Aug 2008 10:53:48 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@elte.hu,
       jens.axboe@oracle.com, a.p.zijlstra@chello.nl, cborntra@de.ibm.com,
       linux-kernel@vger.kernel.org, arjan@infradead.org
References: <48A70185.2020600@goop.org> <48AC6593.80505@goop.org> <20080820122546.6022d91d.akpm@linux-foundation.org>
In-Reply-To: <20080820122546.6022d91d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251053.49033.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 05:25:46 Andrew Morton wrote:
> If stop_machine() is the _only_ problematic callsite and we reasonably
> expect that no new ones will pop up then sure, a
> stop_machine()-specific fix might be appropriate.
>
> Otherwise, sure, we'd need to loko at something more general.

The reason I'm interested is that we have 331 cpu_relax() calls outside the 
arch trees.  That seems like a lot, and I wonder if what they really want is
a spinpletion.

Cheers,
Rusty.
