Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab0BDU6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:58:32 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43010 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab0BDU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:58:30 -0500
Subject: Re: [PATCH 2.6.33-rc6] idr: revert misallocation bug fix
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.sourceforge.net,
       Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <4B6A8C01.5020403@kernel.org>
References: <4B6A8C01.5020403@kernel.org>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 12:58:24 -0800
Message-Id: <1265317104.11442.29.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 17:57 +0900, Tejun Heo wrote:
> Commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d tried to fix
> misallocation bug but broke full bit marking by not clearing
> pa[idp->layers] and also is causing X failures due to lookup failure
> in drm code.  The cause of the latter hasn't been found yet.  Revert
> the fix for now.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Bah.  I just ran into and bisected the X startup problem. :)

Let me know when you have a proper fix.  I can test on my machine for
you.

-- Dave

