Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbZAWXN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbZAWXN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZAWXNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:13:50 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:17713 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbZAWXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:13:49 -0500
X-IronPort-AV: E=Sophos;i="4.37,314,1231113600"; 
   d="scan'208";a="132980694"
From: Roland Dreier <rdreier@cisco.com>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Set up an MTRR covering the GTT at driver load.
References: <1232751258-32611-1-git-send-email-eric@anholt.net>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 23 Jan 2009 15:13:46 -0800
In-Reply-To: <1232751258-32611-1-git-send-email-eric@anholt.net> (Eric
	Anholt's message of "Fri, 23 Jan 2009 14:54:17 -0800")
Message-ID: <adar62t1uqd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jan 2009 23:13:46.0457 (UTC) FILETIME=[3DFE6C90:01C97DB0]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +	dev_priv->mm.gtt_mtrr = -1;
 > +	dev_priv->mm.gtt_mtrr = mtrr_add(dev->agp->base,
 > +					 dev->agp->agp_info.aper_size *
 > +					 1024 * 1024,
 > +					 MTRR_TYPE_WRCOMB, 1);

Two assignments to gtt_mtrr in a row looks a bit odd?

 - R.
