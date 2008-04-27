Return-Path: <linux-kernel-owner+w=401wt.eu-S1758116AbYD0QeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbYD0QeU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 12:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYD0QeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 12:34:05 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:7655 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYD0QeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 12:34:03 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, divy@chelsio.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.26 3/3] RDMA/cxgb3: Support peer-2-peer connection setup.
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>
	<20080427160010.31018.67436.stgit@dell3.ogc.int>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 27 Apr 2008 09:34:00 -0700
In-Reply-To: <20080427160010.31018.67436.stgit@dell3.ogc.int> (Steve Wise's
	message of "Sun, 27 Apr 2008 11:00:10 -0500")
Message-ID: <adatzhn2r5z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Apr 2008 16:34:01.0070 (UTC) FILETIME=[7FA490E0:01C8A884]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What are the interoperability implications of this?

Looking closer I see that iw_nes has the send_first module parameter.
How does this interact with that?

I guess it's fine to apply this, but do we have a plan for how we want
to handle this issue in the long-term?

 - R.
