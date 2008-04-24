Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbYDXKG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbYDXKG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYDXKGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:06:49 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60140 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYDXKGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:06:48 -0400
Date: Thu, 24 Apr 2008 15:36:36 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@clusterfs.com, pbadari@us.ibm.com, cmm@us.ibm.com,
       mathur@linux.vnet.ibm.com, hch@infradead.org
Subject: Re: [PATCH] list_for_each_rcu must die: ext4
Message-ID: <20080424100636.GA3856@skywalker>
References: <20080424012715.GA21836@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424012715.GA21836@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 06:27:15PM -0700, Paul E. McKenney wrote:
> All uses of list_for_each_rcu() can be profitably replaced by the
> easier-to-use list_for_each_entry_rcu().  This patch makes this change for
> the ext4 filesystem, in preparation for removing the list_for_each_rcu()
> API entirely.
> 
> Signed_off_by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

There is already a patch queued at


http://repo.or.cz/w/ext4-patch-queue.git?a=blob;f=ext4-convert-list_for_each_rcu-to_list_for_each_entry_rcu.patch;h=a464d8f2e7e5574f9ab309d4722b075782be227f;hb=HEAD
