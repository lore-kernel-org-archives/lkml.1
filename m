Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYAAHFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYAAHFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYAAHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:05:26 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43745 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYAAHFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:05:25 -0500
Message-ID: <4779DEDA.90207@in.ibm.com>
Date: Tue, 01 Jan 2008 12:04:02 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: ananth@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
References: <200712141225.30099.srinivasa@in.ibm.com> <47676CB7.4060203@in.ibm.com> <200712181823.54382.rusty@rustcorp.com.au> <200712191611.52239.rusty@rustcorp.com.au>
In-Reply-To: <200712191611.52239.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:

> 
> Subject: Don't report discarded init pages as kernel text.
> 
> Current code could cause a bug in symbol_put_addr() if an arch used
> kmalloc module text: we might think the symbol belongs to the core
> kernel.
> 
> The downside is that this might make backtraces through (discarded)
> init functions harder to read on some archs, but we already have that
> issue for modules and noone has complained.


Thanks Rusty,  This patch fixes my problem.
Tested-by: Srinivasa DS <srinivasa@in.ibm.com>
 



