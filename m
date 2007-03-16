Return-Path: <linux-kernel-owner+w=401wt.eu-S965459AbXCPQSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbXCPQSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965461AbXCPQSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:18:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36851 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965459AbXCPQSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:18:41 -0400
Date: Fri, 16 Mar 2007 09:18:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch 24/26] Xen-paravirt_ops: Add the Xenbus sysfs and virtual device hotplug driver.
Message-ID: <20070316161804.GH10574@sequoia.sous-sol.org>
References: <20070301232443.195603797@goop.org> <20070301232529.271605211@goop.org> <20070316084704.GB23174@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316084704.GB23174@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > This communicates with the machine control software via a registry 
> > residing in a controlling virtual machine. This allows dynamic 
> > creation, destruction and modification of virtual device 
> > configurations (network devices, block devices and CPUS, to name some 
> > examples).
> 
> should be reviewed by the driver-core folks too i guess?

Greg has gone through it a couple times.  Any more feedback would
be useful.

> > +//#include <asm/maddr.h>
> 
> > +//#include <xen/xen_proc.h>
> > +//#include <xen/evtchn.h>
> 
> > +//#include <xen/hvm.h>
> 
> > +//		.shutdown = xenbus_dev_shutdown,
> 
> hm?

fixing that up, not sure where that snuck in.
