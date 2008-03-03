Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYCCENP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYCCENP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYCCENA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:13:00 -0500
Received: from ozlabs.org ([203.10.76.45]:47506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYCCEM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:12:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Date: Mon, 3 Mar 2008 15:12:50 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Max Krasnyanskiy <maxk@qualcomm.com>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20080202210828.840735763@polymtl.ca> <47C84DCD.5040803@qualcomm.com> <20080229191559.GA18339@elte.hu>
In-Reply-To: <20080229191559.GA18339@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031512.51656.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008 06:15:59 Ingo Molnar wrote:
> Right now the answer is: "if you want to do hard RT then avoid doing
> things like loading modules". (which you should avoid while doing
> hard-RT anyway)

Hi Ingo,

     I agree, but Max is doing a service by making more people aware of the 
limitations of stop_machine so they don't sprinkle it around like candy :)

I think the module load case can be reasonably fixed; it's in my backlog now.

Cheers,
Rusty.
