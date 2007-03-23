Return-Path: <linux-kernel-owner+w=401wt.eu-S2992597AbXCWWgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992597AbXCWWgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992594AbXCWWgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:36:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41326 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992597AbXCWWgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:36:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Smirnov <svs1957@gmail.com>
Subject: Re: HELP!!! SD and suspend damage i-node.
Date: Fri, 23 Mar 2007 23:38:57 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>
References: <4602781C.9060804@gmail.com> <200703222255.20167.rjw@sisk.pl> <4603B937.9080008@gmail.com>
In-Reply-To: <4603B937.9080008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703232338.57958.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 23 March 2007 12:25, Sergey Smirnov wrote:
> It's happen only with 4G SD. I made the same test in 512Mb SD.
> After suspend/resume there is no errors on fs.
> 
> If I resume PDA with 4G SD it go back to suspend after few seconds.

Well, I believe the problem is related to the SD driver (maintainer added to
the Cc list) or to the zaurus-specific code.

Rafael


> Rafael J. Wysocki wrote:
> > On Thursday, 22 March 2007 13:35, Sergey Smirnov wrote:
> >> I use 2.6.20.2 kernel with ext3 rootfs on 4Gb SD on sharp zaurus sl-750 (PXA255).
> >> After suspend/resume filesystem stay clean. But some i-nodes become broken.
> >> Some files looks like block device or pipe with strange permissions, owner etc.
> >> I'm sure that there is no bad blocks on SD.
> >> I'll send any additional information. Just say me what you need to help me.
> >> I had i lot of tries. Apply patches, remove its, change fstype etc.
> >> output of fsck -f
> > 
> > I assume this is the suspend to RAM?
> > 
> > Rafael
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
