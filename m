Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYJ3Jes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYJ3Jes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbYJ3Jeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:34:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYJ3Jef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:34:35 -0400
Subject: Re: [patch 3/7] mm: make page writeback obey cpuset constraints
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0810300203360.29917@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810280301300.15270@chino.kir.corp.google.com>
	 <1225215134.15763.27.camel@lappy.programming.kicks-ass.net>
	 <alpine.DEB.1.10.0810281216570.30390@chino.kir.corp.google.com>
	 <1225356120.7803.5.camel@twins>
	 <alpine.DEB.2.00.0810300203360.29917@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 10:34:56 +0100
Message-Id: <1225359296.7803.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 02:10 -0700, David Rientjes wrote:

> So perhaps the solution is to introduce populate_nodemask_dirty_limits() 
> and populate_global_dirty_limits() both in mm/page-writeback.c?

Sure, sounds good.
