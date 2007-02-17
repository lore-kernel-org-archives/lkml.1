Return-Path: <linux-kernel-owner+w=401wt.eu-S965014AbXBQE7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbXBQE7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 23:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965018AbXBQE7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 23:59:24 -0500
Received: from ozlabs.org ([203.10.76.45]:44529 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014AbXBQE7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 23:59:23 -0500
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for
	paravirt_ops interface
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@muc.de>, xen-devel@lists.xensource.com,
       virtualization@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
References: <20070216022449.739760547@goop.org>
	 <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 15:58:18 +1100
Message-Id: <1171688298.18876.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 12:49 -0800, Christoph Lameter wrote:
> On Thu, 15 Feb 2007, Jeremy Fitzhardinge wrote:
> 
> > This patch series implements the Linux Xen guest in terms of the
> > paravirt-ops interface.  The features in implemented this patch series
> 
> I am thoroughly confused. Maybe that is because I have not been following 
> this issue closely but it seems that you are using the paravirt interface 
> as an API for Xen code in the guest? I thought the idea of paravirt was to 
> have an API that is generic? This patchset seems to be mostly realizing 
> Xen specific functionality? How does the code here interact with KVM, 
> VMWare and other hypervisors?

It doesn't.  Paravirt_ops provides the hooks.  KVM, lguest, VMI and Xen
all need to implement what they want on top of them.

Hope that clarifies,
Rusty.

