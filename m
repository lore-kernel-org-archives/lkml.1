Return-Path: <linux-kernel-owner+w=401wt.eu-S1762772AbXF0TPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762772AbXF0TPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbXF0TO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:14:56 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:32684 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXF0TOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:14:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CANdTgkarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,467,1175497200"; 
   d="scan'208"; a="5721939:sNHT11867604"
To: Steve Wise <swise@opengridcomputing.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, divy@chelsio.com
Subject: Re: [PATCH 0/6] iw_cxgb3: Bug Fixes for 2.6.23
X-Message-Flag: Warning: May contain useful information
References: <20070627155119.24944.44172.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Jun 2007 12:14:44 -0700
In-Reply-To: <20070627155119.24944.44172.stgit@dell3.ogc.int> (Steve Wise's message of "Wed, 27 Jun 2007 10:51:19 -0500")
Message-ID: <adafy4dryzf.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jun 2007 19:14:44.0521 (UTC) FILETIME=[6B98A990:01C7B8EF]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Here are some bug fixes to the iw_cxgb3 driver that I'd like included
 > for 2.6.23. NOTE: Patch 1 requires a firmware interface change, so
 > there is a version bump to 4.3 included in that patch that hits cxgb3.
 > This will likely conflict with a previous version change that is in
 > Jeff's upstream branch.  The net is: we need the firmware version bumped
 > to 4.3 with these iw_cxgb3 changes.

OK, I'll probably pull this into my tree and hold off on asking Linus
to pull until after he pulls Jeff's net driver tree.  Once that
happens I'll fix up any conflicts and ask Linus to pull.
