Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZFYTYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZFYTYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZFYTYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:24:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57825 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbZFYTYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:24:01 -0400
Date: Thu, 25 Jun 2009 22:23:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: pass value to in_range callback
Message-ID: <20090625192329.GB3239@redhat.com>
References: <20090625125333.GB7166@redhat.com> <4A438E8F.4080008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A438E8F.4080008@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 10:49:51AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > For write transactions, pass the value written to in_range checks so
> > that we can make each iosignalfd a separate device on kvm bus.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >
> > Reposting with a subject now. Sorry.
> >
> > Avi, can you please merge this patch in kvm.git so that
> > Gregory can use it for iosignalfd? Once bus has RCU
> > we'll be able to remove in_range completely, but
> > let's do it step by step.
> >   
> 
> I think this patch will just make more churn for me, not less.  You have
> now convinced me that your io_range-less approach is better.  ;)
> 
> Lets just fix the RCU thing and do it right.  Patch is under development
> as we speak.
> 
> -Greg

So - let's go ahead with this one?

