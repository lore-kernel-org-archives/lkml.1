Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXDKTpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXDKTpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXDKTpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:45:46 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13300 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030284AbXDKTpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:45:45 -0400
Date: Wed, 11 Apr 2007 12:44:38 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Ken Chen <kenchen@google.com>
Cc: akpm@linux-foundation.org, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411194438.GC9602@mami.zabbo.net>
References: <20070410235353.325A7346F64@localhost> <20070411180038.GN28322@mami.zabbo.net> <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >I have mixed feelings.  I think the userspace getevents support was
> >poorly designed and the simple fact that we've gone this long without it
> >says just how desperately the feature isn't needed.
> 
> I kept on getting requests from application developers who want that
> feature.  My initial patch was dated back May 2004.

My point is that demand for it doesn't seem to be very high, and your
use of the past tense there seems to support that.  And the patches to
support it are not looking great.

Is it worth it, then?  What difference are you measuring so far?

- z
