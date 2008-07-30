Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbYG3J1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbYG3J1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYG3J1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:27:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbYG3J1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:27:13 -0400
Date: Wed, 30 Jul 2008 02:26:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Greg KH <gregkh@suse.de>,
       Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000002
Message-Id: <20080730022631.821d34a7.akpm@linux-foundation.org>
In-Reply-To: <20080730090549.GA26904@elte.hu>
References: <20080725095317.GA12636@skywalker>
	<20080728222643.GA6339@slug>
	<1217305335.5553.3.camel@marge.simson.net>
	<20080730090549.GA26904@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 11:05:49 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> > > Hello  Aneesh,
> > > 
> > > On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > > > [  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
> > > > [  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70
> > > 
> > > Does the attached patch solve the problem?
> > 
> > Patch seems to have missed the boat for rc1 too.

I grabbed Andi's 53rd copy and have sent it Linuswards.

> Greg?

We should make him maintain 2.6.27-rc1.1 ;)
