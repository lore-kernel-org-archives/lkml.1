Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZDZMIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZDZMIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750710AbZDZMI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:08:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZDZMIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:08:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #13111] Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
Date: Sun, 26 Apr 2009 14:07:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       benli@broadcom.com, mcarlson@broadcom.com, mchan@broadcom.com,
       holt@sgi.com
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.ScE.fd48JB@chimera> <20090425.181006.246584933.davem@davemloft.net>
In-Reply-To: <20090425.181006.246584933.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904261407.40590.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 April 2009, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sat, 25 Apr 2009 21:31:45 +0200 (CEST)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13111
> > Subject		: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM5701
> > Submitter	: Robin Holt <holt@sgi.com>
> > Date		: 2009-04-08 7:12 (18 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e4f341103e4a2b35f56a0f89802f1b1448e8d04b
> > References	: http://marc.info/?l=linux-kernel&m=123917477312823&w=4
> > 		  http://lkml.org/lkml/2009/4/16/471
> > Handled-By	: Matt Carlson <mcarlson@broadcom.com>
> 
> Fixed by:
> 
> commit 62cedd11f63c99efd2962fb69763a09e2778f6e6
> Author: Matt Carlson <mcarlson@broadcom.com>
> Date:   Mon Apr 20 14:52:29 2009 -0700
> 
>     tg3: Fix SEEPROM accesses
>     
>     The recent NVRAM patches sanitized how the driver deals with NVRAM
>     data, but they failed to bring the SEEPROM interfaces inline with
>     the new strategy.  This patch brings the SEEPROM interfaces up to date.
>     This patch also reverts commit 0d489ffb76de0fe804cf06a9d4d11fa7342d74b9
>     ("tg3: fix big endian MAC address collection failure").
>     
>     Signed-off-by: Matt Carlson <mcarlson@broadcom.com>
>     Signed-off-by: Michael Chan <mchan@broadcom.com>
>     Tested-by: Robin Holt <holt@sgi.com>
>     Tested-by: James Bottomley <james.bottomley@HansenPartnership.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, closed.

Rafael
