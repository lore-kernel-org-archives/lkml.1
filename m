Return-Path: <linux-kernel-owner+w=401wt.eu-S1764397AbXLTOps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764397AbXLTOps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbXLTOpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:45:39 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2859 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbXLTOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:45:39 -0500
Date: Thu, 20 Dec 2007 14:45:32 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sr@denx.de, monstr@monstr.eu, jwilliams@itee.uq.edu.au,
       stephen.neuendorffer@xilinx.com
Subject: Re: [PATCH] [RFC] Xilinx SystemACE: Add media hotplug support
Message-ID: <20071220144532.GA27885@shadowen.org>
References: <20071220062348.16448.24575.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220062348.16448.24575.stgit@trillian.secretlab.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 11:23:48PM -0700, Grant Likely wrote:

> +		/* Make the sysace device 'live' */
> +		if (ace->fsm_state != ACE_FSM_STATE_INVALIDATE_MEDIA);
> +			add_disk(ace->gd);

checkpatch.pl reports the above if as suspect due to the trailing ;.
Looks wrong to me too.

WARNING: Trailing semicolon indicates no statements, indent implies
otherwise
#296: FILE: drivers/block/xsysace.c:835:
+               if (ace->fsm_state != ACE_FSM_STATE_INVALIDATE_MEDIA);
+                       add_disk(ace->gd);

-apw
