Return-Path: <linux-kernel-owner+w=401wt.eu-S2993153AbXEBTa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993153AbXEBTa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993158AbXEBTa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:30:59 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:63879 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766663AbXEBTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:30:35 -0400
Message-ID: <4638E6E6.90206@cfl.rr.com>
Date: Wed, 02 May 2007 15:30:46 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: =?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com> <20070502143839.GA31961@atjola.homenet> <Pine.LNX.4.64.0705021616260.31229@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705021616260.31229@blonde.wat.veritas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 May 2007 19:30:48.0741 (UTC) FILETIME=[632EF550:01C78CF0]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15152.001
X-TM-AS-Result: No--8.768500-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> tmpfs doesn't store its stuff in the page cache twice: that's true,
> and I didn't mean to imply otherwise.  But tmpfs doesn't contain any
> support for rom memory: you'd have to copy from rom to tmpfs to use it.
> 
> Hugh

The question is, when you execute a binary on tmpfs, does its code 
segment get mapped directly where it's at in the buffer cache, or does 
it get copied to another page for the executing process?  At least, 
assuming this is possible due to the vma and file offsets of the segment 
being aligned.
