Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZKWWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZKWWLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757110AbZKWWLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:11:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202AbZKWWLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:11:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Resend][PATCH] Wireless / ath5k: Simplify suspend and resume callbacks
Date: Mon, 23 Nov 2009 23:12:18 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc8-rjw; KDE/4.3.3; x86_64; ; )
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       Bob Copeland <me@bobcopeland.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <200911212344.24170.rjw@sisk.pl> <20091123213353.GA9045@tuxdriver.com>
In-Reply-To: <20091123213353.GA9045@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911232312.18344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 November 2009, John W. Linville wrote:
> On Sat, Nov 21, 2009 at 11:44:24PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: Wireless / ath5k: Simplify suspend and resume callbacks
> > 
> > Simplify the suspend and resume callbacks of ath5k by converting the
> > driver to struct dev_pm_ops and allowing the PCI PM core to do the
> > PCI-specific suspend/resume handling.
> > 
> > Tested with Atheros Communications Inc. AR2413 802.11bg NIC (rev 01)
> > D-Link CardBus.adapter.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> This is already queued for -next.

Thanks!

Rafael
