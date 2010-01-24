Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065Ab0AXAWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab0AXAWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 19:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825Ab0AXAWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 19:22:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34597 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752742Ab0AXAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 19:22:07 -0500
Date: Sun, 24 Jan 2010 00:18:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100124001815.48b4eb9c@lxorguk.ukuu.org.uk>
In-Reply-To: <201001240055.59479.rjw@sisk.pl>
References: <201001240055.59479.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been testing this patch for over a week and haven't seen a single problem
> related to it during this time.
> 
> Are there any objections to it?

Usual question 8) - explain the locking. What happens if we suspend as
kms is initialising/being removed.

Also what happens if you have KMS and non KMS consoles both active
through the frame buffer off different cards ?
