Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZE0UnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZE0UnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZE0UnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:43:00 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:56840 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754600AbZE0Um7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:42:59 -0400
Date: Wed, 27 May 2009 22:31:15 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: David Miller <davem@davemloft.net>
Cc: linux@arm.linux.org.uk, jonsmirl@gmail.com, scottwood@freescale.com,
       jacmet@sunsite.dk, r.schwebel@pengutronix.de,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, yuan-bo.ye@motorola.com,
       timur@freescale.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090527203115.GB16219@game.jcrosoft.org>
References: <9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> <20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> <20090527.132827.65331718.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527.132827.65331718.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Ovh-Tracer-Id: 11942701787086564133
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:28 Wed 27 May     , David Miller wrote:
> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Date: Wed, 27 May 2009 21:39:27 +0200
> 
> > when you have to support the same driver for non OF and OF platform it's
> > really a pain in the ass
> 
> We could embed the platform_device object into the of_platform_device
> structure, it's just an implementation issue.
> 
> But more to the point, I can tell you that anything platform_device
> does can be implemented in terms of of_platform_device but the
> opposite is not true.
This is one of the problem I face not so long ago when I want to the boot
count limit functionnality which is only availlble for of platform

That's why I think having a simplest way to have driver availlable on the
twice platform is important. It will be a win-win at the end

Best Regards,
J.
