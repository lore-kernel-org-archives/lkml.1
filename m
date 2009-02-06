Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZBFUyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZBFUyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZBFUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:53:58 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51530 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbZBFUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:53:57 -0500
Date: Fri, 6 Feb 2009 21:53:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       khali@linux-fr.org, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       frank@f-seidel.de, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090206205354.GA7400@strlen.de>
References: <498C3EEA.5060508@suse.de> <20090206183542.GB6361@strlen.de> <498C96B0.7050408@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <498C96B0.7050408@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Frank,

On Fri, Feb 06, 2009 at 08:59:44PM +0100, Frank Seidel wrote:
> Uwe Kleine-König schrieb:
> > Are you sure about KERN_WARNING?  I havn't looked deeper, but DEB2
> > suggests KERN_DEBUG?  What about fixing DEB[1-3] directly instead of
> > each "call".  e.g.
> 
> No, in this case the DEB* macro was already in many places used
> with KERN_* constants just like direct printk. I didn't wanna
> change that.
> KERN_WARNING is just the standard/default loglevel so that this
> change doesn't introduce different behaviour.
Ah, OK.  Then you have my Acked-by.

Best regards
Uwe
