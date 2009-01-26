Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZAZNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZAZNs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 08:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZAZNst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 08:48:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbZAZNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:48:48 -0500
Subject: Re: [RFC][PATCH 2/2] add a counter for writers spinning on a rwlock
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mandeep Singh Baines <msb@google.com>
In-Reply-To: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
References: <497cd08f.0c11660a.33a7.ffffdf39@mx.google.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 14:48:35 +0100
Message-Id: <1232977715.4863.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-25 at 12:50 -0800, Frederic Weisbecker wrote:
> This patch adds a counter for writers that enter a rwlock slow path.
> For example it can be useful for slow background tasks which perform some jobs
> on the tasklist, such as the hung_task detector (kernel/hung_task.c).
> 
> It adds a inc/dec pair on the slow path and 4 bytes for each rwlocks, so the overhead
> is not null.
> 
> Only x86 is supported for now, writers_spinning_lock() will return 0 on other archs (which
> is perhaps not a good idea).
> 
> Comments?

_why_ ?



