Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZAMDbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZAMDbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZAMDb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:31:29 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:28031 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZAMDb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:31:27 -0500
X-IronPort-AV: E=Sophos;i="4.37,256,1231113600"; 
   d="scan'208";a="59271805"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH mmotm] infiniband: fix iser dependency
References: <200901122101.n0CL1fnr017411@imap1.linux-foundation.org>
	<496BCD45.7010005@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 12 Jan 2009 19:31:26 -0800
In-Reply-To: <496BCD45.7010005@oracle.com> (Randy Dunlap's message of "Mon, 12
	Jan 2009 15:07:49 -0800")
Message-ID: <adar637lw4x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jan 2009 03:31:26.0403 (UTC) FILETIME=[6A4BB930:01C9752F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, I guess we broke this when we added IPv6 support to the rdma_xxx
stuff (INFINIBAND_ISER can be selected with INET=y but IPV6=n in the
current tree, which I guess is how you saw this failure).  applied...
