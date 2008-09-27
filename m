Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbYI0Boo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbYI0Boo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 21:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbYI0Bog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 21:44:36 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:37295 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750887AbYI0Bog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 21:44:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0DAD8t3Uh5LF82iGdsb2JhbACTLAEBARUip2CBZg
X-IronPort-AV: E=Sophos;i="4.33,317,1220193000"; 
   d="scan'208";a="215759642"
Date: Sat, 27 Sep 2008 11:44:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Janos Haar <djani22@netcenter.hu>
Cc: linux-kernel@vger.kernel.org, xfs@premium9.geo.yahoo7.akadns.net
Subject: Re: Whats going on? (somebody can say something?)
Message-ID: <20080927014431.GU27997@disturbed>
Mail-Followup-To: Janos Haar <djani22@netcenter.hu>,
	linux-kernel@vger.kernel.org, xfs@oss.sg.com
References: <2e8201c91fba$1befac80$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e8201c91fba$1befac80$0400a8c0@dcccs>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 11:27:27AM +0200, Janos Haar wrote:
> Hello list,
>
> Good day for everibody.
>
> I have one problem with my new linux box. (again)
> The hw is tested. (memtest86, 4 days)
>
> The samba freezed and makes 40 load.
>
> All what i am using is in-kernel solution, excepting samba.
>
> libata ->bock -> raid -> cryptoloop -> xfs -> [samba] ->eth
>
> The log file is here:
>
> http://download.netcenter.hu/bughunt/20080925/messages
>
> some points:
> Sep 24 01:15:58 - Sep 24 01:19:16 -> i have repaired the 2 xfs on loop0 
> and loop1Sep 24 14:18:00 -> only a little interesting time, when the 
> first bug was issued. (cron?)Sep 25 21:47:39 -> i have logged in.Sep 25 
> 21:50:50 -> i have forced the sysreq from script to make some more debug 
> information.(I have saved the lsof too if somebody interested.)Any help 
> will be appreciated.Thanks a lot,Janos Haar 

What kernel?

I have seen all those XFS oops/stack traces before. With the last
pull request to linus for 2.6.27-rc7, all known causes of the btree
corruption reported in your log messages should be fixed. I guess
you'll have to wait for 2.6.27-rc8 or 2.6.28 for them....

FWIW, next time you have XFS issues, please make it clear in the
subject line and cc xfs@oss.sgi.com.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
