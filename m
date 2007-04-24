Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXDXFtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXDXFtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161633AbXDXFtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:49:25 -0400
Received: from holomorphy.com ([66.93.40.71]:50164 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161010AbXDXFtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:49:24 -0400
Date: Mon, 23 Apr 2007 22:49:37 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: kill all threads that share mm with killed task
Message-ID: <20070424054937.GA19966@holomorphy.com>
References: <Pine.LNX.4.64.0704232134430.11399@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704232134430.11399@chino.kir.corp.google.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 09:36:13PM -0700, David Rientjes wrote:
> oom_kill_task() calls __oom_kill_task() to OOM kill a selected task.
> When finding other threads that share an mm with that task, we need to
> kill those individual threads and not the same one.

ISTR shooting down something of this form a while back. I suppose it
got resurrected.

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
