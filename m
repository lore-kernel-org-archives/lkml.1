Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXA1Rig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXA1Rig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXA1Rif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:38:35 -0500
Received: from dvhart.com ([64.146.134.43]:42645 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbXA1Rif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:38:35 -0500
Message-ID: <45BCDF88.2020504@mbligh.org>
Date: Sun, 28 Jan 2007 09:38:16 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       "Martin J. Bligh" <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@hill9.org>
Subject: Re: lockmeter
References: <20070128115118.837777000@programming.kicks-ass.net> <20070128144325.GB16552@infradead.org> <20070128152404.GB9196@elte.hu> <45BCD4C9.2030302@mbligh.org> <20070128170407.GA1526@infradead.org>
In-Reply-To: <20070128170407.GA1526@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Jan 28, 2007 at 08:52:25AM -0800, Martin J. Bligh wrote:
>> Mmm. not wholly convinced that's true. Whilst i don't have lockmeter
>> stats to hand, the heavy time in __d_lookup seems to indicate we may
>> still have a problem to me. I guess we could move the spinlocks out
>> of line again to test this fairly easily (or get lockmeter upstream).
> 
> We definitly should get lockmeter in.  Does anyone volunteer for doing
> the cleanup and merged?

On second thoughts .. I don't think it'd actually work for this since
the locks aren't global. Not that it shouldn't be done anyway, but ...

ISTR we still thought dcache scalability was a significant problem last
time anyone looked at it seriously - just never got fixed. Dipankar?
