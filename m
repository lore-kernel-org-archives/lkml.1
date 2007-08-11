Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbXHKORg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbXHKORg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXHKOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:17:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62639 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbXHKOR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XwtLwNACQ9bUKBkeTxHR3RFuNIlcyA+DQOTls+MmBRVX64liO0ByeG5d7yttiAnSyqKzc+PQogWWrGf7leT8s4Aenn3HjC3rMNZRDZIxk9X4kJz7nBp6f7tYTmisXnVu85wxHrC3NYzGFFJ76uWa6OA7XpHOTcoxMMLCL2DUdO0=
Date: Sat, 11 Aug 2007 18:17:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] NULL pointer dereference in __vm_enough_memory()
Message-ID: <20070811141714.GA7232@cvg>
References: <20070811132131.GA13775@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811132131.GA13775@mail.ustc.edu.cn>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Fengguang Wu - Sat, Aug 11, 2007 at 09:21:31PM +0800]
| Andrew,
| 
| I'm not sure if this patch is the right fix for the bug.  But it do
| stops the oops message. The bug also happens in 2.6.23-rc1-mm2/2.6.23-rc2-mm2.
| I'm running debian/sid. The .config is attached.
| 
|

[...snip...]

Even if you're right you have to make the same patch for
mm/nommu.c but I've an anticipation the problem is growing
up from another point (and I'm really hoping that I'm wrong ;)

		Cyrill

