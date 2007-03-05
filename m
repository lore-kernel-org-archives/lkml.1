Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXCEN2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXCEN2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965267AbXCEN2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:28:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:52622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965131AbXCEN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:28:47 -0500
Date: Mon, 5 Mar 2007 15:28:20 +0100
From: Andi Kleen <ak@suse.de>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305142820.GD22829@bingen.suse.de>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EC0EB7.7080300@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Can't paravirt patch the syscall instruction like it does the rest of 
> the kernel?

The problem is not the syscall instruction, but some problem with
the way the vDSO mapping is set up with CONFIG_PARAVIRT that broke older glibc.

-Andi
