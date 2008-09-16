Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYIPTSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYIPTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYIPTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:18:37 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:60907 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIPTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:18:36 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Tue, 16 Sep 2008 20:18:27 +0100
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Michael Buesch <mb@bu3sch.de>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net>
In-Reply-To: <48CFE820.7010305@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809162018.28548.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Tue, 16 Sep 2008 19:18:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 18:08:48 Larry Finger wrote:
> I agree with Michael. From what I know, the only possible reason for
> having [RFKILL_STATE_HARD_BLOCKED] would be if user space could
> somehow affect the state of the hardware switch.

When I disable the b43 device in my laptop via acer-wmi (which in turn, calls 
into the laptops firmware), b43 physically cannot re-enable it (a not 
uncommon case on a lot of laptops). In which case, as far as b43 is 
concerned, the wireless radio is then in RFKILL_STATE_HARD_BLOCKED, since b43 
is unable to re-enable the radio on the hardware.

So yes, it is quite possible for b43 to be in RFKILL_STATE_HARD_BLOCKED.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
