Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYBLWCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYBLWCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYBLWCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:02:30 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:57212 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbYBLWC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:02:29 -0500
Message-ID: <47B2174E.5000708@opengridcomputing.com>
Date: Tue, 12 Feb 2008 16:01:50 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: general@lists.openfabrics.org, Christoph Lameter <clameter@sgi.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: Demand paging for memory regions (was Re: MMU Notifiers V6)
References: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>	<20080208234302.GH26564@sgi.com>	<20080208155641.2258ad2c.akpm@linux-foundation.org>	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>	<adaprv70yyt.fsf@cisco.com>	<Pine.LNX.4.64.0802081614030.5115@schroedinger.engr.sgi.com>	<adalk5v0yi6.fsf@cisco.com>	<Pine.LNX.4.64.0802081634070.5298@schroedinger.engr.sgi.com>	<20080209012446.GB7051@v2.random>	<Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>	<20080209015659.GC7051@v2.random>	<Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>	<20080209075556.63062452@bree.surriel.com>	<Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com> <ada3arzxgkz.fsf_-_@cisco.com>
In-Reply-To: <ada3arzxgkz.fsf_-_@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> [Adding general@lists.openfabrics.org to get the IB/RDMA people involved]
> 
> This thread has patches that add support for notifying drivers when a
> process's memory map changes.  The hope is that this is useful for
> letting RDMA devices handle registered memory without pinning the
> underlying pages, by updating the RDMA device's translation tables
> whenever the host kernel's tables change.
> 
> Is anyone interested in working on using this for drivers/infiniband?
> I am interested in participating, but I don't think I have enough time
> to do this by myself.

I don't have time, although it would be interesting work!

> 
> Also, at least naively it seems that this is only useful for hardware
> that has support for this type of demand paging, and can handle
> not-present pages, generating interrupts for page faults, etc.  I know
> that Mellanox HCAs should have this support; are there any other
> devices that can do this?
>

Chelsio's T3 HW doesn't support this.


Steve.
