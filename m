Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbYEBKRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbYEBKRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbYEBKQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:16:56 -0400
Received: from ozlabs.org ([203.10.76.45]:58710 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759296AbYEBKQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:16:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18458.55542.977597.204532@cargo.ozlabs.ibm.com>
Date: Fri, 2 May 2008 19:03:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [POWERPC][v2] Bolt in SLB entry for kernel stack on secondary
	cpus
In-Reply-To: <20080502055648.GA28378@yookeroo.seuss>
References: <18458.39064.783013.268948@cargo.ozlabs.ibm.com>
	<20080502055648.GA28378@yookeroo.seuss>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Gibson writes:

> Do you even need the processor ID test at all?  The boot processor
> should always have its stack covered by SLB entry 0 when we come
> through here, shouldn't it?

I was concerned that get_paca()->kstack wouldn't have been initialized
by the time the boot cpu calls slb_initialize().  If that fear is
unfounded then the check could go.

Paul.
