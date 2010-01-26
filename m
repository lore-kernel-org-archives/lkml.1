Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582Ab0AZE1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0AZE1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535Ab0AZE1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:27:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:57231 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab0AZE1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:27:25 -0500
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@elte.hu>,
       ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <4B5DD9F1.2010002@austin.ibm.com>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop> <26556.1264021443@neuling.org>
	 <4B577F1A.9060907@austin.ibm.com> <1264302028.3601.36.camel@pasglop>
	 <4B5DD9F1.2010002@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 15:23:56 +1100
Message-ID: <1264479836.3601.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 11:50 -0600, Joel Schopp wrote:
> > Look at the cputhreads.h implementation ... Today we only support
> > power-of-two numbers of threads.
> >   
> I've run 3 threads using cpu hotplug to offline 1 of the 4.  It's 
> certainly a stupid idea, but there you go. 

Oh, you mean you need to use the actual online count ? In which case,
yes, you do indeed need to be a bit more careful... In this case though,
you're probably better off special casing "3" :-)

Cheers,
Ben.


