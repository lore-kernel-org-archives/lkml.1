Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0CKND2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:03:28 -0500
Received: from smtp.nokia.com ([192.100.105.134]:58505 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab0CKND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:03:26 -0500
Date: Thu, 11 Mar 2010 14:43:07 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Mike Frysinger <vapier@gentoo.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] USB: musb: fix build error introduced by isoc change
Message-ID: <20100311124307.GR20878@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1268065561-24350-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1268065561-24350-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Mar 2010 12:43:29.0380 (UTC) FILETIME=[73736A40:01CAC118]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 05:26:01PM +0100, ext Mike Frysinger wrote:
>From: Sonic Zhang <sonic.zhang@analog.com>
>
>The recent commit "usb: musb: Fix for isochronous IN transfer" (f82a689fa)
>seems to have been against an older kernel version.  It uses the old style
>naming of variables.  Unfortunately, this breaks building for most MUSB
>users out there since "bDesiredMode" has been renamed to "desired_mode".
>
>Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>Signed-off-by: Mike Frysinger <vapier@gentoo.org>

applied, thanks

-- 
balbi
