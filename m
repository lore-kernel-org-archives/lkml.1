Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbZADSV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbZADSV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 13:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZADSVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 13:21:49 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:24278 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZADSVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 13:21:48 -0500
Message-ID: <4960FE39.2060307@msgid.tls.msk.ru>
Date: Sun, 04 Jan 2009 21:21:45 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz> <4960BB2D.3060000@gmail.com>
In-Reply-To: <4960BB2D.3060000@gmail.com>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander E. Patrakov wrote:
[]
> Ext3 means either hardware that supports barriers (not sure how to
> check, and anyway I have to use encryption on the work laptop due to the
> corporate policy) or disabling write cache (but, as Alan Cox said, this
> shortens the lifespan of the disk). Does this requirement apply to other
> journaling filesystems? Do I need journaling at all, given that I have
> an UPS on my desktop and a battery in the laptop?

There's another possibility too, somewhat more risky.  Namely, run with
write cache ON by default, and switch it off when running off battery
(either UPS or notebook).  Should save both worlds, PROVIDED the battery
actually/UPS works :)

/mjt


