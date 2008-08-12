Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYHLPjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYHLPjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYHLPjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:39:41 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48491 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbYHLPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:39:40 -0400
X-IronPort-AV: E=Sophos;i="4.32,196,1217808000"; 
   d="scan'208";a="139050556"
From: Roland Dreier <rdreier@cisco.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rolandd@cisco.com,
       sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org
Subject: Re: [PATCH] infiniband: change flags from int to long
References: <alpine.DEB.1.10.0808121030160.18695@gandalf.stny.rr.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 12 Aug 2008 08:39:17 -0700
In-Reply-To: <alpine.DEB.1.10.0808121030160.18695@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Tue, 12 Aug 2008 10:32:51 -0400 (EDT)")
Message-ID: <aday732w8d6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Aug 2008 15:39:17.0714 (UTC) FILETIME=[94CF7320:01C8FC91]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It is a bug to have irq saved flags as an int and not long since
 > some archs may use more that 32 bits in flags.

Isn't this already upstream for a while as 52fd8ca6?

 - R.
