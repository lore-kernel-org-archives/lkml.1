Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZCOWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZCOWXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbZCOWXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:23:11 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:56013 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbZCOWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:23:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAN8cvUl5LAJ7/2dsb2JhbADPcoN/Bg
X-IronPort-AV: E=Sophos;i="4.38,368,1233495000"; 
   d="scan'208";a="339248040"
Date: Mon, 16 Mar 2009 09:23:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
Message-ID: <20090315222301.GZ26138@disturbed>
Mail-Followup-To: Alexey Fisher <bug-track@fisher-privat.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49BD1EB7.6080109@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BD1EB7.6080109@fisher-privat.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 04:28:55PM +0100, Alexey Fisher wrote:
> Hallo all.
> I found for my self how great is cache in linux. If read one file from
> disk, so i don't need to do it second time, chace will do the job. It
> speed up thing greatly. But i found it not working with realy big files.
> Like i have 4GB RAM, so if i read a file like 4.6GB, cache won't work.
> Is it possible to have some sort of smart cache wich will read for
> exaplme 1GB from disk and other part from cache?

You're asking for a cache algorithm that can predict the future.
i.e. which bit of that file that is larger than memory is going
to be reused in 10s time?

If you find an algorithm that can tell you this, please let me
know so I can use it to build a flux capacitor. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
