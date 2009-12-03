Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZLCIDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZLCIDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZLCIDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:03:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39897 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZLCIDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:03:39 -0500
Date: Thu, 3 Dec 2009 09:03:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       kay.sievers@vrfy.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sysfs: fix SYSFS_DEPRECATED_V2 prompt
Message-ID: <20091203080341.GA9675@pengutronix.de>
References: <4B0B214A.5020006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B0B214A.5020006@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>  config SYSFS_DEPRECATED_V2
> -	bool "remove sysfs features which may confuse old userspace tools"
> +	bool "enable deprecated sysfs features which may confuse old userspace tools"
Is this better?  SYSFS_DEPRECATED_V2 enables deprecated sysfs features,
but this is done to *not* confuse old userspace tools, isn't it?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
