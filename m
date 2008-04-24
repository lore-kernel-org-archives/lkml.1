Return-Path: <linux-kernel-owner+w=401wt.eu-S1758392AbYDXOMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbYDXOMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYDXOMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:12:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:38324 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYDXOMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:12:05 -0400
Date: Thu, 24 Apr 2008 07:11:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, pbadari@us.ibm.com, cmm@us.ibm.com,
       mathur@linux.vnet.ibm.com, hch@infradead.org
Subject: Re: [PATCH] list_for_each_rcu must die: ext4
Message-ID: <20080424141131.GA9986@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080424012715.GA21836@linux.vnet.ibm.com> <20080424100636.GA3856@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424100636.GA3856@skywalker>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 03:36:36PM +0530, Aneesh Kumar K.V wrote:
> On Wed, Apr 23, 2008 at 06:27:15PM -0700, Paul E. McKenney wrote:
> > All uses of list_for_each_rcu() can be profitably replaced by the
> > easier-to-use list_for_each_entry_rcu().  This patch makes this change for
> > the ext4 filesystem, in preparation for removing the list_for_each_rcu()
> > API entirely.
> > 
> > Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> There is already a patch queued at
> 
> 
> http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4-convert-list_for_each_rcu-to_list_for_each_entry_rcu.patch;h=a464d8f2e7e5574f9ab309d4722b075782be227f;hb=HEAD

Glad to see that you guys are on top of things!!!

Are patches also queued for the list_for_each() -> list_for_each_entry()
conversion?

						Thanx, Paul
