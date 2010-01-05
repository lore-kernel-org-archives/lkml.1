Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386Ab0AEXkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0AEXkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 18:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903Ab0AEXj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 18:39:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:57732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab0AEXj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 18:39:59 -0500
Message-ID: <4B43CEF4.1050903@kernel.org>
Date: Wed, 06 Jan 2010 08:44:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V9 5/7] this_cpu_ops: page allocator conversion
References: <20100104223439.228028923@quilx.com> <20100104223556.613041583@quilx.com> <4B42DCF7.9040609@kernel.org> <alpine.DEB.2.00.1001050921520.1074@router.home>
In-Reply-To: <alpine.DEB.2.00.1001050921520.1074@router.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 12:22 AM, Christoph Lameter wrote:
> On Tue, 5 Jan 2010, Tejun Heo wrote:
> 
>> The above chunk causes build failure due to removed ret used later on
>> return statement.  Changed it to return NOTIFY_OK.
> 
> Thats a change in -next? Patch was against upstream.

I don't think the build failure was specific to the percpu branch.
pageset_cpuup_callback() returns ret on upstream too.

Thanks.

-- 
tejun
