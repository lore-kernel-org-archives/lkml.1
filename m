Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbXLXNx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbXLXNx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 08:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXLXNxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 08:53:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbXLXNxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 08:53:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc6-mm1: suspend broken on HP nx6325 due to cpufreq changes
Date: Mon, 24 Dec 2007 15:13:03 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Jaroslav Kysela <perex@suse.cz>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071223145003.5c36a40a.akpm@linux-foundation.org> <s5hbq8g1goz.wl%tiwai@suse.de>
In-Reply-To: <s5hbq8g1goz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712241513.04072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 24 of December 2007, Takashi Iwai wrote:
> At Sun, 23 Dec 2007 14:50:03 -0800,
> Andrew Morton wrote:
> > 
> > > although it still is a
> > > bit flaky (it takes well more than 5 seconds to suspend and the sound adapter
> > > doesn't work right after the resume, but it starts to work again about 10s
> > > later).
> > 
> > hm.  There have been some suspend changes in the alsa tree.
> 
> Not really.  The usb-audio suspend support is the only addition on
> mm.  It should be irrelevant with on-board HD-audio...

Well, I'm suspecting some ACPI changes, but will be only able to debug it
further in a couple of days.

Rafael
