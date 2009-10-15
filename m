Return-Path: <linux-kernel-owner+w=401wt.eu-S1762566AbZJOJXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbZJOJXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 05:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762555AbZJOJXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 05:23:20 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:44730 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762542AbZJOJXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 05:23:19 -0400
Subject: Re: bdi_threshold slow to reach steady state
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <1255529072.8392.436.camel@twins>
References: <1255518586.2360.78.camel@castor>
	 <1255520272.8392.429.camel@twins>  <1255528520.2360.94.camel@castor>
	 <1255529072.8392.436.camel@twins>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 10:22:34 +0100
Message-Id: <1255598554.2304.1.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 16:04 +0200, Peter Zijlstra wrote:
> On Wed, 2009-10-14 at 14:55 +0100, Richard Kennedy wrote:
> > 
> > commit 11735a2336ba08cf21aebf79a706c86aca5e44b2
> > Author: Richard Kennedy <richard@rsk.demon.co.uk>
> > Date:   Wed Oct 14 14:46:21 2009 +0100
> > 
> >     mm: speed up per bdi dirty threshold calculations
> 
> I think the subject is confusing, we don't actually compute things
> faster in the less cycles sense.
> 
> We reduce the dampening for the control system, yielding faster
> convergence.
Ah yes, sorry about that. That was a bit of a placeholder.

I'll write a proper change log & re-post.
regards
Richard 

