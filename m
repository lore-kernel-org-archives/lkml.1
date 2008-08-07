Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbYHGNMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbYHGNMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYHGNM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:12:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:54628 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYHGNMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:12:24 -0400
Subject: Re: Btrfs v0.16 released
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1217962876.15342.33.camel@think.oraclecorp.com>
References: <1217962876.15342.33.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 11:08:59 +0200
Message-Id: <1218100139.8625.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 15:01 -0400, Chris Mason wrote:

> * Fine grained btree locking.  The large fs_mutex is finally gone.
> There is still some work to do on the locking during extent allocation,
> but the code is much more scalable than it was.

Cool - will try to find a cycle to stare at the code ;-)

> * Helper threads for checksumming and other background tasks.  Most CPU
> intensive operations have been pushed off to helper threads to take
> advantage of SMP machines.  Streaming read and write throughput now
> scale to disk speed even with checksumming on.

Can this lead to the same Priority Inversion issues as seen with
kjournald?

