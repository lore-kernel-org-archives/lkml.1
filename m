Return-Path: <linux-kernel-owner+w=401wt.eu-S932995AbZHUV7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995AbZHUV7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932841AbZHUV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:59:12 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:64105 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbZHUV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:59:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEi1jkqrR7MV/2dsb2JhbAC9Q4g3kFMFhBo
X-IronPort-AV: E=Sophos;i="4.44,252,1249257600"; 
   d="scan'208";a="231450472"
From: Roland Dreier <rdreier@cisco.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [patch] anonfd - split interface into file creation and install
References: <alpine.DEB.2.00.0908211036220.25106@makko.or.mcafeemobile.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 21 Aug 2009 14:59:12 -0700
In-Reply-To: <alpine.DEB.2.00.0908211036220.25106@makko.or.mcafeemobile.com>
	(Davide Libenzi's message of "Fri, 21 Aug 2009 10:48:19 -0700 (PDT)")
Message-ID: <adazl9svnf3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Aug 2009 21:59:12.0918 (UTC) FILETIME=[9E4E0B60:01CA22AA]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > The following patch splits the anonfd interface into a bare file pointer 
 > creation one, and a file pointer creation plus install one.

This would be useful for drivers/infiniband/core/uverbs_main.c -- we
can kill private filesystem for anonymous files with it.  So

Acked-by: Roland Dreier <rolandd@cisco.com>

Thanks,
  Roland
