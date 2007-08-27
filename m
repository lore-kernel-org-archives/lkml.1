Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbXH1Gtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbXH1Gtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXH1Gtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:49:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:40533 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbXH1Gtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:49:45 -0400
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@qumranet.com>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1187763956.6174.48.camel@localhost.localdomain>
References: <46CBC842.4070100@vmware.com>  <46CBCADF.2070400@qumranet.com>
	 <1187763956.6174.48.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 19:54:41 +0200
Message-Id: <1188237281.5972.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 16:25 +1000, Rusty Russell wrote:
> On Wed, 2007-08-22 at 08:34 +0300, Avi Kivity wrote:
> > Zachary Amsden wrote:
> > > This patch provides hypercalls for the i386 port I/O instructions,
> > > which vastly helps guests which use native-style drivers.  For certain
> > > VMI workloads, this provides a performance boost of up to 30%.  We
> > > expect KVM and lguest to be able to achieve similar gains on I/O
> > > intensive workloads.
> > 
> > Won't these workloads be better off using paravirtualized drivers? 
> > i.e., do the native drivers with paravirt I/O instructions get anywhere
> > near the performance of paravirt drivers?
> 
> This patch also means I can kill off the emulation code in
> drivers/lguest/core.c, which is a real relief.

Hrm... how do you deal with X doing IOs ?

Ben.


