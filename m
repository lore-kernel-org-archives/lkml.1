Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXDQVjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXDQVjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXDQVjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:39:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35878 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964821AbXDQVjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:39:44 -0400
Date: Tue, 17 Apr 2007 14:39:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Larry Woodman <lwoodman@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl_panic_on_oom broken
In-Reply-To: <462515CC.1080107@redhat.com>
Message-ID: <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
References: <462515CC.1080107@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Larry Woodman wrote:

> out_of_memory() does not panic when sysctl_panic_on_oom is set
> if constrained_alloc() does not return CONSTRAINT_NONE.  Instead,
> out_of_memory() kills the current process whenever constrained_alloc()
> returns either CONSTRAINT_MEMORY_POLICY or CONSTRAINT_CPUSET.
> This patch fixes this problem:

It recreates the old problem that we OOM while we still have memory 
in other parts of the system.
