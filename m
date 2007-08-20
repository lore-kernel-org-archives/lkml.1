Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXHTCCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXHTCCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbXHTCCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:02:10 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:45667 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752423AbXHTCCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:02:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NZEycTt3tIyHmnoSyPnigvuUwXDqbQvPVdTKIn1fxR8McJXvRtZ0OOxnwemPKiY8YpSw0KWppXg/onQdF2s+NiJy6Z/Uo0vjtAn8mcCugXoM9LJ1E/yB1DoW049T75qDErRrfC0/V5G9zLFU3RiZIizbJUQshHgX05OS+6IvDcU=  ;
X-YMail-OSG: _NFrxbYVM1mIr_lIHkQPFfLdUem_fF6fcpB4ZNd.KG05DgBT.oNZPXvjWqhFw1DI9Z9ad2Oo6o4L9XbdMSO6rhsSlJJi0z.DApByAcQ8G1_7ZzOcKNseEGj.nzGv0ks1MyvhvfI8OcSKtvk-
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Date: Sun, 19 Aug 2007 19:02:04 -0700
User-Agent: KMail/1.9.6
Cc: Kay Sievers <kay.sievers@vrfy.org>, jengelh@computergmbh.de,
       a.zummo@towertech.it, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com, greg@kroah.com
References: <200708170902.01260.david-b@pacbell.net> <1187559950.4419.79.camel@lov.localdomain> <200708191848.21410.david-b@pacbell.net>
In-Reply-To: <200708191848.21410.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191902.04966.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, David Brownell wrote:
> On Sunday 19 August 2007, Kay Sievers wrote:
> > No, I object to the concept of "platform" to disable all uevents by
> > default, 
> 
> Which it certainly doesn't do.
>
> Since the $SUBJECT patch doesn't affect a platform driver in any case,
> all those comments are well off-topic for $SUBJECT.

Sorry, my bad -- I was looking at the wrong files.
(Kay -- apply cluebat to *my* head, on this point.)

This is indeed a platform driver.  And v2 of this patch
doesn't resolve its "won't hotplug" problem.  The simplest
way to resolve that would be switching to the more widely
used platform_device_register().



