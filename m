Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZBYSQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZBYSQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbZBYSQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:16:26 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:55470 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZBYSQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:16:25 -0500
Date: Wed, 25 Feb 2009 20:16:12 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] usb: musb: - kill the compile warning
Message-ID: <20090225181611.GL31792@frodo>
Reply-To: me@felipebalbi.com
References: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:23:30PM +0800, Bryan Wu wrote:
> drivers/usb/musb/musb_core.c:1433: warning: assignment makes pointer
> from integer without a cast
> 	hw_ep->target_regs = musb_read_target_reg_base(i, mbase);
> 
> static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase);
> 
> this is a common bug, but a bug still ?  mbase is a 32/64 bit pointer,
> but we return a u16 to assign to a pointer ?  seems odd :)
> 
> So return right pointer in the stub.
> 
> Cc: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

any new version coming ??

-- 
balbi
