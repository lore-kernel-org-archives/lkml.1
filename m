Return-Path: <linux-kernel-owner+w=401wt.eu-S1751428AbXBOAuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbXBOAuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXBOAuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:50:23 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:8971 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbXBOAuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:50:22 -0500
X-IronPort-AV: i="4.14,170,1170662400"; 
   d="scan'208"; a="762961210:sNHT42007792"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, hch@infradead.org, raisch@de.ibm.com,
       h.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1 4/5] ehca: replace yield() by wait_for_completion()
X-Message-Flag: Warning: May contain useful information
References: <200702141741.35444.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Feb 2007 16:50:06 -0800
In-Reply-To: <200702141741.35444.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Wed, 14 Feb 2007 17:41:35 +0100")
Message-ID: <adahctow8g1.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Feb 2007 00:50:09.0282 (UTC) FILETIME=[3DF2BE20:01C7509B]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with Christoph -- the use of wait_for_completion() in a loop
makes no sense.  When you send a new copy of this patch without
whitespace damage, please fix that up too...
