Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYBSVbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYBSVbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbYBSVbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:31:40 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59649 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755050AbYBSVbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:31:39 -0500
Message-ID: <47BB4AB8.9020509@sgi.com>
Date: Tue, 19 Feb 2008 13:31:36 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Alan.Brunelle@hp.com,
       linux-kernel@vger.kernel.org, npiggin@suse.de, dgc@sgi.com,
       arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
References: <47B0B69B.1050807@hp.com>	<47B46008.9020804@hp.com>	<20080218123717.GW23197@kernel.dk> <20080219151418.97557f0f.pj@sgi.com>
In-Reply-To: <20080219151418.97557f0f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Jens wrote:
>> My main worry with the current code is the ->lock in the per-cpu
>> completion structure.
> 
> Drive-by-comment here:  Does the patch posted later this same day by Mike Travis:
> 
>   [PATCH 0/2] percpu: Optimize percpu accesses v3
> 
> help with this lock issue any?  (I have no real clue here -- just connecting
> up the pretty colored dots ;).
> 

I'm not sure of the context here but a big motivation for doing the
zero-based per_cpu variables was to optimize access to the local
per cpu variables to one instruction, reducing the need for locks.

-Mike
