Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZBLLKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZBLLKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 06:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757140AbZBLLJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 06:09:59 -0500
Received: from smtp.nokia.com ([192.100.122.230]:21659 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbZBLLJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 06:09:58 -0500
Date: Thu, 12 Feb 2009 12:55:17 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <cooloney@kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] usb: musb: - kill the compile warning
Message-ID: <20090212105517.GY12881@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1233915810-18616-1-git-send-email-cooloney@kernel.org> <200902112203.25428.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902112203.25428.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 12 Feb 2009 11:09:30.0647 (UTC) FILETIME=[60930A70:01C98D02]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 07:03:25AM +0100, David Brownell wrote:
> On Friday 06 February 2009, Bryan Wu wrote:
> > -       return (MUSB_BUSCTL_OFFSET(i, 0) + mbase);
> > +       return (void __iomem *)(MUSB_BUSCTL_OFFSET(i, 0) + mbase);
> 
> Why is MUSB_BUSCTL_OFFSET() returning something other than
> an integer?  "mbase" is already "void __iomem *", so the only
> way that should trigger a warning is if that OFFSET() macro
> is doing something odd.

The warning only comes on Blackfin's version of this, this hunk is
unnecessary

-- 
balbi
