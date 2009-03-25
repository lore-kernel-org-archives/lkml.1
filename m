Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbZCYOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbZCYOQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbZCYOQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:16:03 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:40694 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCYOQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:16:01 -0400
X-IronPort-AV: E=Sophos;i="4.38,419,1233532800"; 
   d="scan'208";a="161379796"
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org,
       Eli Cohen <eli@mellanox.co.il>
Subject: Re: RDMA/InfiniBand merge plans for 2.6.30
References: <ada4oxiwa1y.fsf@cisco.com> <200903251358.06128.arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 25 Mar 2009 07:15:58 -0700
In-Reply-To: <200903251358.06128.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 25 Mar 2009 13:58:05 +0100")
Message-ID: <adahc1hvgbl.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2009 14:15:59.0196 (UTC) FILETIME=[3867E1C0:01C9AD54]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > There are some patches in the ofed release by Eli and me to support
 > weak ordering on DMA ("ib_core: Use weak ordering for data registered
 > memory"). When they got merged into OFED, I assumed they would find
 > their way into mainline along with most of the other patches in there.
 > 
 > Did they get forgotten about, or did I misunderstand the process?

Oh yeah, forgot about that weak ordering.  I still want to have a think
about that (I don't like having a module parameter for it but maybe
there's not better way)

However in general getting into OFED is pretty unrelated to getting
upstream...

 - R.
