Return-Path: <linux-kernel-owner+w=401wt.eu-S934353AbZLPA5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbZLPA5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934343AbZLPA5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:57:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:36532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934322AbZLPA5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:57:40 -0500
Message-ID: <4B2830CC.7040309@kernel.org>
Date: Wed, 16 Dec 2009 09:58:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and	cleanup
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal>
In-Reply-To: <20091215174302.GA3928@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mathieu.

On 12/16/2009 02:43 AM, Mathieu Desnoyers wrote:
> So I think accessing the "local_t offset" through percpu pointers should
> be fine if I allocate struct ltt_chanbuf through the per cpu API.
> However, I wonder how to deal with the commit_count counters, because
> there is an indirection level.

Are they different in numbers for different cpus?

Thanks.

-- 
tejun
