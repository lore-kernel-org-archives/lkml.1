Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393Ab0AXDDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0AXDDO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 22:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136Ab0AXDDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 22:03:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:45391 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab0AXDDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 22:03:12 -0500
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <4B577F1A.9060907@austin.ibm.com>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop> <26556.1264021443@neuling.org>
	 <4B577F1A.9060907@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Jan 2010 14:00:28 +1100
Message-ID: <1264302028.3601.36.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 16:09 -0600, Joel Schopp wrote:
> I can turn that into a conditional branch (case statement) with a shift 
> for the common 1,2,4 cases which should cover all procs available today 
> falling back to a divide for any theoretical future processors that do 
> other numbers of threads. 

Look at the cputhreads.h implementation ... Today we only support
power-of-two numbers of threads.

Cheers,
Ben.


