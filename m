Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZA3AAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZA3AAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 19:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZA3AAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 19:00:41 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:29326 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZA3AAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 19:00:40 -0500
X-BigFish: VPS-25(zz1432R98dR1805Mzzzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <49824308.6020209@am.sony.com>
Date: Thu, 29 Jan 2009 16:00:08 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: PS3: replace bus_id usage
References: <20090126173019.GA12010@kroah.com>
In-Reply-To: <20090126173019.GA12010@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2009 00:00:08.0809 (UTC) FILETIME=[B6E22590:01C9826D]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> These simple debug statments should be using dev_dbg() instead of
> accessing bus_id directly (or they should use device_name).
> 
> As bus_id is going away, this patch is necessary.
> 
> Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
> 
> This fixes a built-breakage in linux-next.  I'll be glad to keep this in
> my tree if you don't want to take it in yours, just let me know.
> 
>  arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This looks OK.  Greg, please merge it through your tree.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>


