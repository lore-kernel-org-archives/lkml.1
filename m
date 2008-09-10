Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbYIJFin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbYIJFin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYIJFid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:38:33 -0400
Received: from ns.suse.de ([195.135.220.2]:53409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYIJFid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:38:33 -0400
Date: Tue, 9 Sep 2008 22:37:24 -0700
From: Greg KH <gregkh@suse.de>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       htejun@gmail.com
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Message-ID: <20080910053724.GA3632@suse.de>
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 07:11:02PM -0400, Parag Warudkar wrote:
> Tejun's commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15 made sysfs
> attribute->owner unnecessary.
> But the field was left in the structure to ease the merge. It's been
> over a year since that change and it is now time to start killing
> attribute->owner along with its users - one arch at a time!

Why one arch, normally we do it one subsystem at a time :)

Either way, thanks for doing this, I'll gladly take your fixed up
version and work to clean up the rest if you don't want to do it.

thanks,

greg k-h
