Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbXHREG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbXHREG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 00:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbXHREGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 00:06:46 -0400
Received: from smtp121.sbc.mail.re3.yahoo.com ([66.196.96.94]:48751 "HELO
	smtp121.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750728AbXHREGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 00:06:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5Dm9gi52Gygudbr0Frs/VJ+FaJZS0fDFl2FdRf7GMawgbPJpDQwtMqO125CJIVYL/1V3prIxYMyTsBC69d+8IcYEJxvx6DazYe7APA71IE1T5f75b3APyET+f561NKV9oI3WXyceNZcbbMcUwbLuIgmP/amb09WCGsyox7OOwXk=  ;
X-YMail-OSG: uCMArj8VM1ng_Zqr65c3M._gXXPdW6BL9YmHtHm6JDt2DLti
From: David Brownell <david-b@pacbell.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 21:06:51 -0700
User-Agent: KMail/1.9.6
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>
References: <200708170823.15894.david-b@pacbell.net> <200708171250.09653.david-b@pacbell.net> <1187404839.4419.5.camel@lov.localdomain>
In-Reply-To: <1187404839.4419.5.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708172106.52940.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Kay Sievers wrote:
> 
> > I'm not the one who's advocating a change here.  If you want to
> > first change/break and then fix things, all of that is up to you.
> 
> I'm happy to do that. Patch is attached.

NAK.  That wasn't even a serious attempt at the "fix" part,
though it does the "break" part well enough to cause severe
regressions.

(As well as leaving all my technical points about your pushback
un-addressed.  As I noted before, the evident fact that you don't
have technical responses to them says to me that your pushback
has no real technical basis ...)


Out of around 300 platform drivers in the tree (and many more
not yet merged upstream), this makes it so that only *THREE* of
them can hotplug ... versus in the current tree, essentially
everything that's not a legacy driver is hotplugging just fine.

That's one heck of a regression.  Just shy of 100% ...

Plus it treats rtc-ds1742 as if it's a platform_driver not
an i2c_driver.

- Dave

