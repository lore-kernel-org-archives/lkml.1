Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbZJMOoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbZJMOoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbZJMOo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:44:29 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:58630 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759880AbZJMOo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:44:28 -0400
Date: Tue, 13 Oct 2009 10:36:13 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] this_cpu: Use this_cpu_xx in trace_functions_graph.c
In-Reply-To: <4AD48EC4.8040701@kernel.org>
Message-ID: <alpine.DEB.1.10.0910131035450.11413@gentwo.org>
References: <20091013144812.bdb376aa.sfr@canb.auug.org.au> <4AD48EC4.8040701@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Tejun Heo wrote:

> ftrace_cpu_disabled usage in trace_functions_graph.c were left out
> during this_cpu_xx conversion in commit 9288f99a causing compile
> failure.  Convert them.

Thanks.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
