Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZDET0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZDET0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZDET0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:26:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41249 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbZDET0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:26:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: Resume failure: ata3.01: revalidation failed (errno=-2)
Date: Sun, 5 Apr 2009 21:25:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090325064503.GA4959@dose.home.local>
In-Reply-To: <20090325064503.GA4959@dose.home.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904052125.59799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009, Tino Keitel wrote:
> Hi,
> 
> I tried if I can get reliable suspend to RAM on my new Mac mini Core 2
> Duo using 2.6.29, and did a "burn in" test with an endless
> suspend/resume loop using RTC wakeup. After ~30 attempts, the kernel
> hangs with a screen full of this message:
> 
> ata3.01: revalidation failed (errno=-2)
> 
> In the kernel log, I see _one_ occurrence of this message at each resume:
> 
> kern.debug: ata3.01: NODEV after polling detection
> kern.err: ata3.01: revalidation failed (errno=-2)
> 
> I tried the same using 2.6.27.20 and got the same, after 52 attempts.

Can you run this test with the current mainline, please?

Rafael
