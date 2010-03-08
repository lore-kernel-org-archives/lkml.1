Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0CHSes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:34:48 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:43780 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0CHSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:34:43 -0500
Date: Mon, 8 Mar 2010 20:34:54 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] USB: musb: fix build error introduced by isoc change
Message-ID: <20100308183453.GF6630@gandalf>
Reply-To: me@felipebalbi.com
References: <1268065561-24350-1-git-send-email-vapier@gentoo.org>
 <5A47E75E594F054BAF48C5E4FC4B92AB0321623721@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB0321623721@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 10:01:45PM +0530, Gadiyar, Anand wrote:
> Mike Frysinger wrote:
> > 
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > 
> > The recent commit "usb: musb: Fix for isochronous IN transfer" (f82a689fa)
> > seems to have been against an older kernel version.  It uses the old style
> > naming of variables.  Unfortunately, this breaks building for most MUSB
> > users out there since "bDesiredMode" has been renamed to "desired_mode".
> > 
> 
> Looks like this code is under a "#ifdef USE_MODE1" check; that's why
> we did not find this during regular builds. Felipe's upcoming patches
> would make this code redundant anyway.
> 
> Till then, we might as well fix it.

yes, it was my bad. I should have reviewed the code more carefully. We
will be testing the mode1 support on DaVinci during this and the next
week and when we get it working, we will publish the mode1 dma changes
again which will completely change this code.

> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Acked-by: Anand Gadiyar <gadiyar@ti.com>

Acked-by: Felipe Balbi <felipe.balbi@nokia.com>

-- 
balbi
