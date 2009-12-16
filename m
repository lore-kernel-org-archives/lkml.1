Return-Path: <linux-kernel-owner+w=401wt.eu-S933370AbZLPBpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370AbZLPBpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932595AbZLPBo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:44:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:34333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbZLPBo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:44:56 -0500
Message-ID: <4B283BFE.2040005@kernel.org>
Date: Wed, 16 Dec 2009 10:46:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and	cleanup
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal>
In-Reply-To: <20091216014031.GA12282@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/16/2009 10:40 AM, Mathieu Desnoyers wrote:
> Nope, there is the same number of sub-buffers for each per-cpu buffer.
> I just want to see if supplementary indirections are allowed after
> dereferencing the per-cpu pointer ?

Hmmm... you can store percpu pointer to a variable.  If there are the
same number of commit_count for each cpu, they can be allocated using
percpu allocator and their pointers can be stored, offset and
dereferenced.  Would that be enough?

Thanks.

-- 
tejun
