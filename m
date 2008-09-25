Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYIYRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYIYRnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIYRnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:43:11 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:59868 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYIYRnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:43:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=kPQ3Rq6gQwSk4ZDJ/2aMZfjB5CoVQfQc8zyT0U0AClvsAcXrNDAjzQ9qZsGmUA2a;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <48DBCDAC.4010003@earthlink.net>
Date: Thu, 25 Sep 2008 13:43:08 -0400
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: sclark46@earthlink.net
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26.5 hangs on boot
References: <48DBAD73.3000202@earthlink.net>
In-Reply-To: <48DBAD73.3000202@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79097f32a9fa0c7f41e5591e25cf2cf467350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
> Hello,
> 
> Vanilla kernel 2.6.26.5 hangs on boot right after displaying
> isapnp: Scanning For PnP cards ...
> isapnp: No Plug & Play device found
> 
> I have to power off my laptop to get out of this state. I never had this 
> problem with previous kernels.
> 
> Redhat Bugzilla has other people with this problem. I had it too so I 
> compiled
> a vanilla kernel to make sure it wasn't vendor specific.
> https://bugzilla.redhat.com/show_bug.cgi?id=462156
> 
> If I append clocksource=hpet then the kernel will boot - but I shouldn't 
> have to do this.
> 
> My laptop is an asus z96f with a core 2 duo processor.
> 
> Steve
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
This seems to be fixed in 2.6.27-rc7

Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


