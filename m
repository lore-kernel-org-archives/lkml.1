Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbXHPPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbXHPPBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbXHPPBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:01:32 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:55949 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004AbXHPPBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:01:30 -0400
X-IronPort-AV: i="4.19,272,1183359600"; 
   d="scan'208"; a="514166033:sNHT1211418960"
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@osdl.org>, Andy Whitcroft <apw@shadowen.org>,
       Roland Dreier <rolandd@cisco.com>,
       Sean Hefty <mshefty@ichips.intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       general@lists.openfabrics.org
Subject: Re: [PATCH 4/6] infiniband: mlx4_MAD_IFC copies out response unconditionally
X-Message-Flag: Warning: May contain useful information
References: <exportbomb.1187270320@pinky>
	<65fd31510014453ccd0a99a20c83deb5@pinky>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 16 Aug 2007 08:01:19 -0700
In-Reply-To: <65fd31510014453ccd0a99a20c83deb5@pinky> (Andy Whitcroft's message of "Thu, 16 Aug 2007 14:19:01 +0100")
Message-ID: <ada7inv34n4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Aug 2007 15:01:19.0450 (UTC) FILETIME=[4D5273A0:01C7E016]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > It seems a trailing ';' has slipped into mlx4_MAD_IFC() which causes
 > the response to be copied out unconditionally.

Thanks -- this is the third time someone has sent me this patch in the
last day ;)

 - R.
