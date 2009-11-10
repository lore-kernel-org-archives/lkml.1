Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZKJMjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZKJMjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZKJMjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:39:15 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:53084 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbZKJMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:39:15 -0500
Date: Tue, 10 Nov 2009 13:39:16 +0100
From: Daniel Mack <daniel@caiaq.de>
To: David Newall <davidn@davidnewall.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
Message-ID: <20091110123916.GX14091@buzzloop.caiaq.de>
References: <4AF7DDC1.4090006@ladisch.de>
 <20091109095316.6283fbd6@lxorguk.ukuu.org.uk>
 <4AF7FC64.6030904@ladisch.de>
 <20091109114600.4d91b90e@lxorguk.ukuu.org.uk>
 <20091109145056.GB14091@buzzloop.caiaq.de>
 <4AF8582B.2000403@davidnewall.com>
 <20091109220944.GH14091@buzzloop.caiaq.de>
 <4AF956F8.7090707@davidnewall.com>
 <20091110123008.GW14091@buzzloop.caiaq.de>
 <4AF95E6A.3030103@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF95E6A.3030103@davidnewall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:06:58PM +1030, David Newall wrote:
> Daniel Mack wrote:
> > "A couple of seconds" is still too much. We don't want to give the
> > impression of a terminal at all. The whole application starting
> > afterwards has no cursor either.
> 
> Or even half a second. Devices regularly flash and squiggle on startup,
> often as a diagnostic. Did you look at initialising your display
> controller in graphics mode, or with the cursor off?

It's a dumb framebuffer device, fbcon handles the rest. From the moment
when the framebuffer is initalized until the userspace comes up, it
takes ~5 secs, and at this time, we don't want to see the cursor.


