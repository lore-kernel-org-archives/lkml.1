Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbZBXW4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbZBXW4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZBXW4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:56:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50580 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbZBXW4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:56:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Suspend regression with 2.6.29-rc
Date: Tue, 24 Feb 2009 23:55:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090224190850.GA27800@dose.home.local>
In-Reply-To: <20090224190850.GA27800@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242355.50212.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Tino Keitel wrote:
> Hi,
> 
> with 2.6.28, I have sporadic suspend failures with suspend to RAM on my
> Mac mini core duo (Intel Core Duo, i945 chipset and graphics).  I
> traced it down to the DRM driver: without X and DRM unloaded, I had
> more than 200 suspens in a row without any failure.
> 
> With 2.6.29-rc6-00029-gf7e603a, even with DRM unloaded the computer
> hangs at suspend time after some attempts.  I also tried other
> 2.6.29-rc kernels, and all had unstable suspend behaviour.  I can't
> give any further details, as the console is dark and I have no serial
> console.  Any hints what I might try except for bisecting?

Well, this most likely is a result of the recent PCI PM core changes, but
it's hard to say which of them exactly is responsible in this particular case.

Please open a bug at bugzilla.kernel.org with a CC to me and put your system
information in there (the output of 'lspci -vv', /proc/iomem, /proc/interrupts,
boot log).

Also please try to reproduce the problem in the minimal configuration
(init=/bin/bash, /proc and /sys mounted manually).

Thanks,
Rafael
