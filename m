Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYCDCht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYCDCht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 21:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYCDChl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 21:37:41 -0500
Received: from ozlabs.org ([203.10.76.45]:43064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbYCDChk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 21:37:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Date: Tue, 4 Mar 2008 13:36:56 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20080202210828.840735763@polymtl.ca> <200803031512.51656.rusty@rustcorp.com.au> <47CC983C.8050000@qualcomm.com>
In-Reply-To: <47CC983C.8050000@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041336.56524.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 11:30:52 Max Krasnyanskiy wrote:
> Great. I might get some time later this week to think about this some more
> and try things out. So if you have ideas/suggestions let me know.

Hmm, might be worth making stop_machine_run take a cpumask: I balked at it 
originally, but introducing a section special case crosses the line I think.

Thanks,
Rusty.
