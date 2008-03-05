Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbYCES5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbYCES5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYCES5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:57:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42712 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbYCES5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:57:41 -0500
Date: Wed, 5 Mar 2008 10:53:01 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/5] object debugging infrastructure V2
Message-ID: <20080305185301.GA2861@kroah.com>
References: <20080305154829.185609547@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305154829.185609547@linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 04:03:33PM -0000, Thomas Gleixner wrote:
> This is version 2 of the object debugging infrastructure. Changes
> versus V1:
> 
> - review comments processed:
>   - multiplexing interfaces replaced
>   - object type is determined by a caller provided pointer to 
>     a debug structure which replaces the object type identifier
>     -> No changes to the core code for new users
>   - new debug state "destroyed" (kobject wishlist)
>   - various cleanups
> 
> - complete detachment of the tracker object from the real object
>   (no change to the real objects data structure necessary anymore)
> 
> - improved robustness (object memory management, oom cleanup)
> 
> - full set of self tests
> 
> - debugfs statistics 
> 
> - docbook documentation

This looks very nice, thanks for the documentation as well.

I'll work on adding kobjects to this infrastructure and send you a patch
if it works out well.

thanks,

greg k-h
