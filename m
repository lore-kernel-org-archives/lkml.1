Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXCRApE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXCRApE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbXCRApE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:45:04 -0400
Received: from ozlabs.org ([203.10.76.45]:32832 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbXCRApC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:45:02 -0400
Subject: Re: [Xen-devel] Re: [patch 20/26] Xen-paravirt_ops: Core Xen
	implementation
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@xensource.com>,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
In-Reply-To: <20070316091411.GF23174@elte.hu>
References: <20070301232443.195603797@goop.org>
	 <20070301232528.812011702@goop.org>  <20070316091411.GF23174@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 20:13:47 +1100
Message-Id: <1174122827.8897.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 10:14 +0100, Ingo Molnar wrote:
> > +unsigned long xen_pmd_val(pmd_t pmd)
> > +{
> > +	BUG();
> > +	return 0;
> > +}
> 
> make it noret.

OK, I missed this one.  How?

Wondering if I've missed a trick here...
Rusty.


