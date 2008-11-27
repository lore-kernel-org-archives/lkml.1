Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYK0IF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYK0IF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYK0IFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:05:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:59454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYK0IFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:05:19 -0500
Subject: Re: Lockdep warning for iprune_mutex at shrink_icache_memory
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20081126213454.GI6291@disturbed>
References: <20081125064357.5a4f1420@tuna> <20081126072625.GH6291@disturbed>
	 <1227711779.4454.184.camel@twins>  <20081126213454.GI6291@disturbed>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Nov 2008 09:05:15 +0100
Message-Id: <1227773115.4454.1208.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 08:34 +1100, Dave Chinner wrote:
> Is changing the lock class dynamically possible/allowed?

Currently, no, but I'll see what I can do, it requires a bit of trickery
to make that happen..

I'll let you know when I've sorted that out.
