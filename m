Return-Path: <linux-kernel-owner+w=401wt.eu-S1764284AbZFLKZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764284AbZFLKZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbZFLKZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:25:30 -0400
Received: from firestarter.dermichi.com ([83.64.48.195]:47627 "EHLO
	firestarter.dermichi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933722AbZFLKZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:25:29 -0400
X-Greylist: delayed 1699 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 06:25:29 EDT
Message-ID: <4A32266F.8080607@dermichi.com>
Date: Fri, 12 Jun 2009 11:57:03 +0200
From: Michael Weissenbacher <mw@dermichi.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Felix Blyakher <felixb@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30: Memory/XFS leak, OOM killer kills many processes
References: <alpine.DEB.2.00.0906111158470.2563@p34.internal.lan>	<alpine.DEB.2.00.0906111255280.6809@p34.internal.lan>	<4A313F84.20900@sandeen.net>	<96F5FBF8-17B6-4AA9-BAB4-377AF596692C@sgi.com> <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0906120420080.26259@p34.internal.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> So just goto line ~6086 and add the kmem_free(out); above the return error.
> 
> Status:
> This patch fixes the problem, thanks!
> 
Applied here too & fixes the problem. Wow, the fix was provided in <3 hours, kudos to open source.

Michael
