Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZICRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZICRkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZICRky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:40:54 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:47613 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZICRkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:40:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAE+cn0qrR7MV/2dsb2JhbADDA4hBAZAvBYQb
X-IronPort-AV: E=Sophos;i="4.44,326,1249257600"; 
   d="scan'208";a="237090727"
From: Roland Dreier <rdreier@cisco.com>
To: tziporet@dev.mellanox.co.il
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       linux-rdma@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.32
References: <adar5upos9z.fsf@cisco.com> <4A9FB004.6020904@mellanox.co.il>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 03 Sep 2009 10:40:55 -0700
In-Reply-To: <4A9FB004.6020904@mellanox.co.il> (Tziporet Koren's message of
	"Thu, 03 Sep 2009 15:01:08 +0300")
Message-ID: <ada4orkoriw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Sep 2009 17:40:55.0763 (UTC) FILETIME=[B0A69A30:01CA2CBD]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > What about RDMAoE?
 > Patches were sent few weeks ago and it seems you ignore them.

Sorry, I should have mentioned that.

Yes, I have been ignoring the patches -- I want to get through XRC
first, and also I would like to see a real spec for IBoE (that resolves
issues like multicast interaction with IGMP, address resolution, etc) so
we can judge whether the current patches match the long-term direction
or are just a point-in-time hack.

 - R.
