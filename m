Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZITKB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZITKB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 06:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZITKB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 06:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:57152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZITKB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 06:01:26 -0400
Message-ID: <4AB5FD4D.3070005@kernel.org>
Date: Sun, 20 Sep 2009 19:00:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       sachinp@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>	 <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com>
In-Reply-To: <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 10:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Fri, Sep 18, 2009 at 10:34 PM, Mel Gorman <mel@csn.ul.ie> wrote:
>> SLQB used a seemingly nice hack to allocate per-node data for the statically
>> initialised caches. Unfortunately, due to some unknown per-cpu
>> optimisation, these regions are being reused by something else as the
>> per-node data is getting randomly scrambled. This patch fixes the
>> problem but it's not fully understood *why* it fixes the problem at the
>> moment.
> 
> Ouch, that sounds bad. I guess it's architecture specific bug as x86
> works ok? Lets CC Tejun.

Is the corruption being seen on ppc or s390?

Thanks.

-- 
tejun
