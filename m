Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXLEJSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXLEJSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 04:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXLEJR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 04:17:58 -0500
Received: from ns2.suse.de ([195.135.220.15]:56688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbXLEJR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 04:17:57 -0500
Date: Wed, 5 Dec 2007 10:17:55 +0100
From: Nick Piggin <npiggin@suse.de>
To: Dave Airlie <airlied@linux.ie>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 03/18] drm: nopage
Message-ID: <20071205091755.GB1114@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net> <20071205071627.081149000@nick.local0.net> <Pine.LNX.4.64.0712050904170.395@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712050904170.395@skynet.skynet.ie>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 09:05:06AM +0000, Dave Airlie wrote:
> 
> > Convert drm from nopage to fault.
> > Remove redundant vma range checks.
> 
> Hi Nick,
> 
> can you rebase against the -mm tree? or are you pushing this for before 
> then? if so can you supply me a patch against -mm?

I'm not sure where I am in the pecking order, although there are some
security issues (I didn't cc you on that patch, doh). So the patches
are against mainline to give the option of merging them earlier.

All the patches except 17/18 are standalone, however. So if any of them
don't apply for Andrew, I can do another pass to catch the remainders.
I'll definitely help you with the new drm VM one way or the other ;)

