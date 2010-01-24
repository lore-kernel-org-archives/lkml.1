Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569Ab0AXTDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0AXTDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 14:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127Ab0AXTDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 14:03:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45040 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab0AXTDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 14:03:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume if KMS is used
Date: Sun, 24 Jan 2010 20:04:22 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
References: <201001240055.59479.rjw@sisk.pl> <20100124001815.48b4eb9c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100124001815.48b4eb9c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001242004.22778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 January 2010, Alan Cox wrote:
> > I've been testing this patch for over a week and haven't seen a single problem
> > related to it during this time.
> > 
> > Are there any objections to it?
> 
> Usual question 8) - explain the locking. What happens if we suspend as
> kms is initialising/being removed.

Nothing extremely interesting AFAICS.  There's no X yet or it's already exited,
so we don't need a VT switch anyway.

> Also what happens if you have KMS and non KMS consoles both active
> through the frame buffer off different cards ?

That's more interesting.  In fact I didn't take that into consideration. :-)
