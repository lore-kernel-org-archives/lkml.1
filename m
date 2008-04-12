Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbYDLQPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbYDLQPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 12:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYDLQPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 12:15:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37155 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYDLQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 12:14:59 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 12 Apr 2008 18:14:37 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] firewire: fw-ohci: fix debug logging of phy packets
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f3c267b896f5d604@s5r6.in-berlin.de>
Message-ID: <tkrat.d9db3519cd83e9ff@s5r6.in-berlin.de>
References: <tkrat.f3c267b896f5d604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> --- linux.orig/drivers/firewire/fw-ohci.c
> +++ linux/drivers/firewire/fw-ohci.c
> @@ -371,10 +371,10 @@ static void log_ar_at_event(char dir, in
>  	if (unlikely(evt >= ARRAY_SIZE(evts)))
>  			evt = 0x1f;
>  
> -	if (header[0] == ~header[1]) {
> +	if (header[1] == ~header[2]) {
>  		printk(KERN_DEBUG "A%c %s, %s, %08x\n",
> -		       dir, evts[evt], phys[header[0] >> 30 & 0x3],
> -		       header[0]);
> +		       dir, evts[evt], phys[header[1] >> 30 & 0x3],
> +		       header[1]);

This patch is bogus.  The indices were right.
-- 
Stefan Richter
-=====-==--- -=-- -==--
http://arcgraph.de/sr/

