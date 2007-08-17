Return-Path: <linux-kernel-owner+w=401wt.eu-S1764837AbXHQUUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764837AbXHQUUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 16:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760564AbXHQUUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 16:20:11 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:26966 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752372AbXHQUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 16:20:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aNbG+Y+e915Fk/Fbx2lh/gK8NAp9vS87e7DKUh+mnKzaXDmDBBpcdW6dE4ykqLCFNznyRMamTJaZGrVE8IkLKWqapapN/nxl+tPFZnFJj/4+hWJhinzM/LKfbuDWvRMdLmN3ekO7p1ZIbADEdXRc0icuJ2cObxhgoYYb3FbzjNQ=  ;
X-YMail-OSG: ixKDlewVM1mUaJ6RG6mmvDZirhQpZd1Up0LJ5FPa8dhHfqJxBregYN309ZluSck2XnpTT1DZK8l0FXJxwI4wOTvuI4eaDzvNPezpTkBW9n6WxU8YLqOFA.UGvWwloJI8yZG4vygGRkiiKf0-
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Fri, 17 Aug 2007 13:20:05 -0700
User-Agent: KMail/1.9.6
Cc: Kay Sievers <kay.sievers@vrfy.org>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, Greg KH <greg@kroah.com>
References: <200708170823.15894.david-b@pacbell.net> <200708171250.09653.david-b@pacbell.net> <Pine.LNX.4.64.0708172151050.5186@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708172151050.5186@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171320.05734.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 August 2007, Jan Engelhardt wrote:
> >> We exchanges several mails a few weeks ago after the Debian bug caused
> >> by a modprobe loop. 
> >
> >Which has been fixed for some time now; it was caused by legacy
> >drivers, which are incapable of hotplugging.
> 
> Speaking of which ... does not platform: thing affect pcspkr and psmouse for
> x86 too?

psmouse is a serio driver, not a platform driver.

pcspkr is a platform driver, but not a legacy driver.
It could be made to hotplug.
