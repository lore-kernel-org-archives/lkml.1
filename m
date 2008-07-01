Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYGAR5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYGAR5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYGAR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:57:10 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:32627 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbYGAR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:57:08 -0400
X-IronPort-AV: E=Sophos;i="4.27,732,1204531200"; 
   d="scan'208";a="121032515"
From: Roland Dreier <rdreier@cisco.com>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org
Subject: Re: [RFC PATCH] - scripts/CodingStyle_sizeof - standardize sizeof and [PATCH] drivers/infiniband - standardize sizeof(foo)
References: <1214930986.26073.40.camel@localhost>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Jul 2008 10:57:07 -0700
In-Reply-To: <1214930986.26073.40.camel@localhost> (Joe Perches's message of
	"Tue, 01 Jul 2008 09:49:46 -0700")
Message-ID: <adar6adcwss.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2008 17:57:07.0331 (UTC) FILETIME=[E0895D30:01C8DBA3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems like needless churn to me.  I personally prefer to see
"sizeof foo" instead of "sizeof(foo)", since sizeof is not a function,
and in any case I don't see much value in making this type of trivial
change.
