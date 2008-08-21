Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYHUMkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYHUMkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYHUMkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:40:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37185 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYHUMkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:40:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: resume from ram hangs on 2.6.26+ kernels on thinkpad z60m
Date: Thu, 21 Aug 2008 14:43:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200808201602.26848.arekm@maven.pl>
In-Reply-To: <200808201602.26848.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211443.43690.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of August 2008, Arkadiusz Miskiewicz wrote:
> 
> I'm seeing problems with resume (using s2ram) on thinkpad z60m notebook with 
> very fresh git kernel (built yesterday). It looks like this - I get screen 
> resumed with X window running on it, I see mouse pointer but pointer doesn't 
> react to movement and sysrq keys also don't respond (tried to 
> umount+sync+reboot via sysrq).
> 
> The hangs doesn't always happen but it happens quite often (often enough to 
> get kmail trashed several times).
> 
> The problem is also happening on 2.6.26 kernels (I wasn't testing .26 too 
> much).
> 
> Now I'm back on 2.6.25 where the problem doesn't occur.
> 
> I didn't see any reports related  to that on lkml which is bad thing 8)
> 
> Any ideas?

Not really.  We must have broken something in 2.6.26, but there were not too
many suspend-specific patches in there vs .25.

What s2ram options are used?

What hardware is there in the box (chipset, graphics)?

Thanks,
Rafael
