Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbXFZN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbXFZN5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbXFZN5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 09:57:07 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44758
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342AbXFZN5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 09:57:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] hw_random: add quality categories
Date: Tue, 26 Jun 2007 15:56:26 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200706241555.22957.mb@bu3sch.de> <20070625162156.18c1abba.akpm@linux-foundation.org>
In-Reply-To: <20070625162156.18c1abba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261556.26934.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 June 2007 01:21:56 Andrew Morton wrote:
> On Sun, 24 Jun 2007 15:55:22 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > The qualities of the HWRNGs are different from each other.
> > So the current default policy of the hwrng core to default
> > to the first found RNG is broken. This changes the default
> > policy to select the RNG with the best quality category.
> > So for a machine with a bcm43xx and a RNG in the CPU it
> > would always default to the RNG in the CPU, as that's the
> > better one.
> > Of course, the selection can still be changed from userspace.
> 
> I'm presently having git disasters with the wireless tree and am unable to
> include it in the -mm lineup so the hunk against
> drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c doesn't apply here.
> 
> I stuck that change into a second patch and commented it out.  I will
> hopefully remember to bring that patch back when git-wireless gets sorted
> out.

Ok, thanks. I'll tell you, in case you forget it.

-- 
Greetings Michael.
