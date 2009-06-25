Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZFYOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZFYOyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZFYOyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 10:54:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbZFYOyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 10:54:10 -0400
Date: Thu, 25 Jun 2009 17:53:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [KVM PATCH v8 1/3] KVM: make io_bus interface more robust
Message-ID: <20090625145341.GC7221@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003035.15859.33528.stgit@dev.haskins.net> <4A438825.5000606@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A438825.5000606@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:22:29AM -0400, Gregory Haskins wrote:
> Gregory Haskins wrote:
> > Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_ON if it
> > fails.  We want to create dynamic MMIO/PIO entries driven from userspace later
> > in the series, so we need to enhance the code to be more robust with the
> > following changes:
> >
> >    1) Add a return value to the registration function
> >    2) Fix up all the callsites to check the return code, handle any
> >       failures, and percolate the error up to the caller.
> >    3) Add an unregister function that collapses holes in the array

Does not unregister need rcu bus fixes to work?

-- 
MST
