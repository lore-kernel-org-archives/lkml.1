Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbZGFTnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbZGFTnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZGFTng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:43:36 -0400
Received: from fmailhost02.isp.att.net ([207.115.11.52]:44758 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZGFTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:43:34 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A5253F1.50504@lwfinger.net>
Date: Mon, 06 Jul 2009 14:43:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: chunkeey@web.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
References: <4a524b55.wIWqgs5uHs2CpdJy%Larry.Finger@lwfinger.net>	<20090706.121429.36217952.davem@davemloft.net>	<200907062119.25642.chunkeey@web.de> <20090706.123441.246532764.davem@davemloft.net>
In-Reply-To: <20090706.123441.246532764.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christian Lamparter <chunkeey@web.de>
> Date: Mon, 6 Jul 2009 21:19:25 +0200
> 
>> On Monday 06 July 2009 21:14:29 David Miller wrote:
>>> If I can't figure it out quickly I'll just simply revert.
>> hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
>> [2.6.31] p54: band-aid to restore driver functionality
>> http://patchwork.ozlabs.org/patch/28918/
>>
>> in case someone missed it.
> 
> It is so much cleaner to not do multiple things in one patch.
> 
> It's also better to completely revert the SKB list handling
> changes first, then add whatever other fixes you want make
> on top.
> 
> Partial revert really makes no sense here and is only asking
> for even more potential regressions.
> 
> So, like I said, I'm reverting this wholesale unless I can figure
> out a fix quickly.

I'm available for testing.

Larry
