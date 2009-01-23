Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbZAWXP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbZAWXP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 18:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbZAWXPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 18:15:14 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:52366 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbZAWXPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 18:15:12 -0500
X-IronPort-AV: E=Sophos;i="4.37,314,1231113600"; 
   d="scan'208";a="235664574"
From: Roland Dreier <rdreier@cisco.com>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Work around PAGE_KERNEL_WC not getting WC in iomap_atomic_prot_pfn.
References: <1232751258-32611-1-git-send-email-eric@anholt.net>
	<1232751258-32611-2-git-send-email-eric@anholt.net>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 23 Jan 2009 15:15:11 -0800
In-Reply-To: <1232751258-32611-2-git-send-email-eric@anholt.net> (Eric
	Anholt's message of "Fri, 23 Jan 2009 14:54:18 -0800")
Message-ID: <adamydh1uo0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Jan 2009 23:15:11.0363 (UTC) FILETIME=[709A0D30:01C97DB0]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > +	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
 > +	  prot = PAGE_KERNEL_UC_MINUS;

indentation broke here (the "prot =" line is indented with a tab then
two spaces, instead of two tabs)

 - R.
