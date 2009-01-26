Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZAZR62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZAZR62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZAZR57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:57:59 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:9543 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZAZR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:57:57 -0500
X-IronPort-AV: E=Sophos;i="4.37,326,1231113600"; 
   d="scan'208";a="133597950"
From: Roland Dreier <rdreier@cisco.com>
To: Divy Le Ray <divy@chelsio.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Steve Wise <swise@opengridcomputing.com>,
       Linux Network Development list <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 2.6.30] cxgb3 - notify iWARP of chip resets
References: <497DF609.9000600@chelsio.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 26 Jan 2009 09:57:54 -0800
In-Reply-To: <497DF609.9000600@chelsio.com> (Divy Le Ray's message of "Mon, 26
	Jan 2009 09:42:33 -0800")
Message-ID: <adaeiyqymot.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Jan 2009 17:57:55.0295 (UTC) FILETIME=[9D75D6F0:01C97FDF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm submitting 2 patches against cxgb3 and iw_cxgb3 respectively.
 > They are built against net-next-2.6.
 > The first patch adds a notification mechanism to cxgb3 to alert
 > the upper layer drivers (iWARP and iSCSI) of a chip reset.
 > 
 > The second patch adds the handler for such an event in the iWARP driver.
 > 
 > Since the second patch depends on the first one, I submit them together,
 > even though the second patch should be submitted against Roland's tree.

simplest thing is for Dave to merge both, and I'm fine with that.

 - R.
