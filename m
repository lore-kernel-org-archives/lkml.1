Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbYD0PtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbYD0PtB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 11:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYD0Psx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 11:48:53 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45510 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152AbYD0Psw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 11:48:52 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 11:48:52 EDT
Message-ID: <48149F2B.4000503@lwfinger.net>
Date: Sun, 27 Apr 2008 10:43:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Priit Laes <plaes@plaes.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [REGRESSION] Trouble seeing some wireless networks in latest
 git
References: <1209288298.3851.12.camel@localhost>
In-Reply-To: <1209288298.3851.12.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Priit Laes wrote:
> Hey,
> 
> There seems to be some kind of regression in wireless drivers that makes
> it not possible to see some wireless networks.
> 
> This can be seen with both b43 and iwl3945 drivers.
> 
> Using Kismet wireless scanner these networks were visible under latest
> git.
> All the networks rendered invisible seem to be from channels: 1 (one
> network visible), 3, 8, 12 and 13. Visible networks are in channels 1,
> 4, 6, 9 and 11.
> 
> Any hints how to debug this further?

This regression sounds like a perfect place to use git bisection. As it affects 
b43 and iwl3945, I would suspect some change in mac80211.

Larry
