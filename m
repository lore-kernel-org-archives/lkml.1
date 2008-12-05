Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYLEPOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYLEPOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYLEPON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:14:13 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35048 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbYLEPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:14:12 -0500
Message-ID: <49394541.30404@lwfinger.net>
Date: Fri, 05 Dec 2008 09:14:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
References: <200812051547.45790.chunkeey@web.de>
In-Reply-To: <200812051547.45790.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Lamparter wrote:
> This patch fixes a problem identified by Johannes Berg.
> 
> It looks like this is a classic case of "use-after-freed". 
> A module which should reproduce the problem on
> any other USB device can be found right here:
> http://kerneltrap.org/mailarchive/linux-usb/2008/12/4/4317064

I didn't find either the code nor a link to it in the above link. What did I miss?

Larry
