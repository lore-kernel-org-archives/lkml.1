Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYB0Wmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYB0Wmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYB0Wmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:42:45 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51274 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754240AbYB0Wmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:42:44 -0500
Date: Wed, 27 Feb 2008 16:42:32 -0600
From: Jack Steiner <steiner@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Message-ID: <20080227224232.GA18581@sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> > Also, what we are going to need here are not skeleton drivers
> > that just do all the *easy* bits (of registering their callbacks),
> > but actual fully working examples that do everything that any
> > real driver will need to do. If not for the sanity of the driver
> > writer, then for the sanity of the VM developers (I don't want
> > to have to understand xpmem or infiniband in order to understand
> > how the VM works).
> 
> There are 3 different drivers that can already use it but the code is 
> complex and not easy to review. Skeletons are easy to allow people to get 
> started with it.


I posted the full GRU driver late last week. It is a lot of
code & somewhat difficult to understand w/o access to full chip
specs (sorry). The code is fairly well commented &  the
parts related to TLB management should be understandable.


