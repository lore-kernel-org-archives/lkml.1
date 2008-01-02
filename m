Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbYABXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbYABXtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYABXtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:49:08 -0500
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:34393
	"EHLO QMTA05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797AbYABXtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:49:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=sGE9Mcn9CyMA:10 a=dwR8q1bI2sQtoxzSypAA:9 a=voBrfO6jdX3qMvs7gxvk45kqGy4A:4 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
From: Nicholas Miell <nmiell@comcast.net>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "K. Prasad" <prasad@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dipankar@in.ibm.com, ego@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080102163309.GC11496@redhat.com>
References: <20071231060911.GB6461@in.ibm.com>
	 <20071231102045.GB30380@elte.hu> <y0modc4vr7a.fsf@ton.toronto.redhat.com>
	 <20080102124734.GC11208@elte.hu>  <20080102163309.GC11496@redhat.com>
Content-Type: text/plain
Date: Wed, 02 Jan 2008 15:49:03 -0800
Message-Id: <1199317743.2438.8.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.0.njm.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-02 at 11:33 -0500, Frank Ch. Eigler wrote:
> Hi -
> 
> On Wed, Jan 02, 2008 at 01:47:34PM +0100, Ingo Molnar wrote:
> > [...]
> > > FWIW, I'm not keen about the format strings either, but they don't 
> > > constitute a performance hit beyond an additional parameter.  It does 
> > > not need to actually get parsed at run time.
> > 
> > "only" an additional parameter. The whole _point_ behind these markers 
> > is for them to have minimal effect!
> 
> Agreed.  The only alternative I recall seeing proposed was my own
> cartesian-product macro suite that encodes parameter types into the
> marker function/macro name itself.  (Maybe some of that could be
> hidden with gcc typeof() magic.)  There appeared to be a consensus
> that this was more undesirable.  Do you agree?
> 
> 

C++ name mangling would be extremely useful here.


Actually, why isn't the DWARF information for the functions sufficient?

-- 
Nicholas Miell <nmiell@comcast.net>

