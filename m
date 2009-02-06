Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZBFUAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZBFUAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZBFUAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:00:10 -0500
Received: from mail.suse.de ([195.135.220.2]:59842 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969AbZBFUAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:00:08 -0500
Message-ID: <498C96B0.7050408@suse.de>
Date: Fri, 06 Feb 2009 20:59:44 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= <ukleinek@strlen.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       frank@f-seidel.de, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
References: <498C3EEA.5060508@suse.de> <20090206183542.GB6361@strlen.de>
In-Reply-To: <20090206183542.GB6361@strlen.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Kleine-König schrieb:
> Are you sure about KERN_WARNING?  I havn't looked deeper, but DEB2
> suggests KERN_DEBUG?  What about fixing DEB[1-3] directly instead of
> each "call".  e.g.

No, in this case the DEB* macro was already in many places used
with KERN_* constants just like direct printk. I didn't wanna
change that.
KERN_WARNING is just the standard/default loglevel so that this
change doesn't introduce different behaviour.

Thanks,
Frank
