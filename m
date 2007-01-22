Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbXAVVOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbXAVVOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXAVVOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:14:12 -0500
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:41986 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbXAVVOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:14:11 -0500
X-IronPort-AV: i="4.13,221,1167638400"; 
   d="scan'208"; a="357292228:sNHT44583220"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openfabrics-ewg@openib.org, openib-general@openib.org,
       raisch@de.ibm.com
Subject: Re: [PATCH 2.6.20 2/2] ehca: ehca_irq.c: fix mismatched spin_unlock in irq handler
X-Message-Flag: Warning: May contain useful information
References: <200701192251.01888.hnguyen@linux.vnet.ibm.com>
	<200701201620.16097.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 22 Jan 2007 13:14:06 -0800
In-Reply-To: <200701201620.16097.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Sat, 20 Jan 2007 16:20:15 +0100")
Message-ID: <adaps96n4rl.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jan 2007 21:14:07.0000 (UTC) FILETIME=[40533980:01C73E6A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queued for 2.6.20 (although I left the line a little longer).

I think the right thing to do is restructure this function so you
don't have lines starting 6 tab stops to the right.

 - R.
