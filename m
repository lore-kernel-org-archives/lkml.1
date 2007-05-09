Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbXEILE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbXEILE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbXEILES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:04:18 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:51714 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbXEILER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:04:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=peusxXizMwzVFi2bmwCo/uAmyDmKmo7SgoHT8/WwtUr6+7yrlTqOSKA5NXHKn
	IJf+fzZGFEDqZ91gdjlglHy1w==
Date: Wed, 9 May 2007 13:04:15 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Marcus Better <marcus@better.se>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - Ethernet and HSS
Message-ID: <20070509110415.GA7513@xi.wantstofly.org>
References: <464034CF.20700@wpkg.org> <f1s2eu$26p$1@sea.gmane.org> <20070509092132.GB6976@xi.wantstofly.org> <200705091135.06405.marcus@better.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705091135.06405.marcus@better.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 11:35:03AM +0200, Marcus Better wrote:

> > Does that mean that the Debian ARM people have their heads so far
> > up their collective asses that they think that every form of change
> > is bad and are unable to accept that some forms of change might be
> > for the better?
> 
> Well, I am not one of the Debian ARM people, just a user... and I
> do hope the EABI port becomes supported in the future! But in the
> meatime there is a crowd of users running Debian on consumer devices
> like the NSLU2, and they need a LE network driver.

"There's a crowd of users running Linux on TCP offload capable
cards, and they need TCP offload support in Linux."

The people who need a LE network driver can use Christian's driver,
as Christian's driver works in LE just fine.  The people who care
about LE support can add LE support to the driver that Krzysztof wrote.

I don't think that not supporting LE is a reason not to merge
Krzysztof's driver.  Don't make supporting LE systems Krzysztof's
problem.

Krzysztof has written an excellent driver, and while it would be 100%
Debian style to reject his driver just because it doesn't support LE[*],
thankfully, Linux is not Debian.  Please don't turn Linux into Debian.


[*] And if he were to complain about this, he would get slapped with
    the standard "Our priorities are our users and free software"
    Debian Social Contract rhetoric -- thank $DEITY we don't have a
    Linux Kernel Social Contract with the same bullshit in it.
