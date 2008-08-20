Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYHTBw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYHTBw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYHTBwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:52:49 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:22794 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355AbYHTBws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:52:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANYTq0h5LD0w/2dsb2JhbAC2QIFb
X-IronPort-AV: E=Sophos;i="4.32,238,1217773800"; 
   d="scan'208";a="175109274"
Date: Wed, 20 Aug 2008 11:52:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kevin Diggs <kevdig@hypersurf.com>
Cc: linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, arnd@arndb.de
Subject: Re: {NOT a PATCH} Corrections please ...
Message-ID: <20080820015244.GA6061@disturbed>
Mail-Followup-To: Kevin Diggs <kevdig@hypersurf.com>,
	linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de,
	arnd@arndb.de
References: <48AB73A3.9010404@hypersurf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB73A3.9010404@hypersurf.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 06:30:11PM -0700, Kevin Diggs wrote:
> Hi,
>
> 	It was recommended that I use a completion in a driver I am working on.  
> While figuring out how to use one, I noticed that there was no kernel  
> doc block comments. I am trying to add them. I would rather not have to  
> respin the patch for corrections.

Rather than documenting exactly how the queuing and wakeup occurs on
all functions, you should document it once. i.e. that completions
currently use FIFO queuing. It is probably best to do this at the
definition of the struct completion.

The reason is that if the implementation changes (e.g. to support
priorities and inheritence) the comments are then incorrect and
then there's lots of comments to remove^Wchange.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
