Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545Ab0ATV6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0ATV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379Ab0ATV6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:58:06 -0500
Received: from ozlabs.org ([203.10.76.45]:58612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab0ATV6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:58:02 -0500
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Joel Schopp <jschopp@austin.ibm.com>, ego@in.ibm.com,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
In-reply-to: <1264020517.4283.1117.camel@laptop>
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <1264020517.4283.1117.camel@laptop>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Wed, 20 Jan 2010 21:48:37 +0100."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 21 Jan 2010 10:58:01 +1300
Message-ID: <29111.1264024681@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
> > there is performance benefit to idling the higher numbered threads in
> > the core.  
> 
> So this is an actual performance improvement, not only power savings?

It's primarily a performance improvement.  Any power/energy savings
would be a bonus.  

Mikey
