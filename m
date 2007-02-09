Return-Path: <linux-kernel-owner+w=401wt.eu-S1946356AbXBIMDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946356AbXBIMDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946389AbXBIMDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:03:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:54062 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1946356AbXBIMDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:03:19 -0500
X-Provags-ID: V01U2FsdGVkX18sO2gtHZMsczL4l4thV/scW8Tsaiyibn2g2cRe8V
	xvLg==
Date: Fri, 9 Feb 2007 13:03:14 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk, pomac@vapor.com,
       chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
Subject: Re: SATA exceptions with 2.6.20-rc5
Message-ID: <20070209120314.GA19001@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk,
	pomac@vapor.com, chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
References: <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no> <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no> <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no> <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no> <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no> <45B697D3.4070707@shaw.ca> <20070124003923.GA3093@atjola.homenet> <20070203014215.GA28126@atjola.homenet> <45C4221E.7050201@shaw.ca> <20070204011351.GA2069@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070204011351.GA2069@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.02.04 02:13:51 +0100, Björn Steinbrink wrote:
> On 2007.02.02 23:48:14 -0600, Robert Hancock wrote:
> > There's a patch in -mm (sata_nv-use-adma-for-nodata-commands.patch) 
> > which should hopefully avoid this problem for the cache flush commands, 
> > at least - can you try that one out? You'll have to apply the other 
> > sata_nv patches in -mm first, i.e. this order:
> > 
> > http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2.patch
> > http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
> > http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-use-adma-for-nodata-commands.patch
> 
> Got 2.6.20-rc7 with them applied now (the rejects seemed trivial enough
> for me to fix them). Let's see how that works out...

After about 1.5 days of uptime, an involuntary reboot and another 3
days of uptime, no sign of an exception. No stress testing was done,
but a few disk intensive actions did happen, at least more than with
that -rc6 that did throw an exception at me.

Björn
