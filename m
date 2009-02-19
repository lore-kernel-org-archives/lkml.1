Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZBSJkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZBSJkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbZBSJkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:40:37 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:33441 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZBSJkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:40:37 -0500
Date: Thu, 19 Feb 2009 12:40:42 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, rth@twiddle.net, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: binfmt_aout fix
Message-ID: <20090219094042.GA19049@jurassic.park.msu.ru>
References: <20090217104956.GC25856@jurassic.park.msu.ru> <20090217110842.GA22272@infradead.org> <20090217114054.GA26176@jurassic.park.msu.ru> <20090218155231.8b8c8b9f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218155231.8b8c8b9f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 03:52:31PM -0800, Andrew Morton wrote:
> It would make sense to register the core, default handlers first and
> to permit arch-specific handlers to then override (or to front-end) the
> core handlers.

Yes, sounds good. I'll make a patch for 2.6.30.

> But that sounds a bit risky for 2.6.29.  Is this fix needed in 2.6.29? 
> If so, perhaps we should merge version 1 as a temporary thing.  But if
> so, please let's not do the temporary-thing-which-hangs-around-forever thing?

Just drop it. The bug is not so terribly critical (I don't think that a lot
of people are using osf binaries these days).

Ivan.
