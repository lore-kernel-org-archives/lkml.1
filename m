Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbXJQWKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbXJQWKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXJQWKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:10:09 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:30874 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbXJQWKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:10:07 -0400
X-IronPort-AV: E=Sophos;i="4.21,291,1188802800"; 
   d="scan'208";a="536692785"
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] file operations: release can race with read/write?
X-Message-Flag: Warning: May contain useful information
References: <adave96ki0x.fsf@cisco.com> <adaodexh9uz.fsf@cisco.com>
	<20071017193320.GK8181@ftp.linux.org.uk>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 17 Oct 2007 15:10:04 -0700
In-Reply-To: <20071017193320.GK8181@ftp.linux.org.uk> (Al Viro's message of "Wed, 17 Oct 2007 20:33:21 +0100")
Message-ID: <adabqaxgzpf.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Oct 2007 22:10:05.0349 (UTC) FILETIME=[78C39D50:01C8110A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Of _course_ you can trigger that - just open two files and have write
 > on one of them while another gets closed.

Right, thanks for the explanation.

 - R.
