Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZCCS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZCCS44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZCCS4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:56:48 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42360 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249AbZCCS4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:56:48 -0500
Date: Tue, 3 Mar 2009 13:46:52 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903031345150.9466@qirst.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com> <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com> <alpine.DEB.1.10.0903031136380.26454@qirst.com> <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, David Rientjes wrote:

> There is no alternative solution to prevent egregious amounts of slab to
> be allocated in a disjoint cpuset that is supposedly mem_exclusive.

The amount of memory is limited by the size of a slab page. If the process
goes beyond that amount then the page allocator will come in and enforce
the boundaries.


