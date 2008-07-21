Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYGUQQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYGUQQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYGUQQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:16:24 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:41906 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYGUQQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:16:24 -0400
Date: Mon, 21 Jul 2008 11:14:33 -0500
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Dave Jones <davej@redhat.com>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Message-ID: <20080721161433.GD13185@loki.buserror.net>
References: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net> <20080716214722.GA6251@ld0162-tx32.am.freescale.net> <20080716215745.GA17093@redhat.com> <37829F82-D71C-4B42-A752-DA86C6F2764D@kernel.crashing.org> <20080716221949.GA18148@redhat.com> <BB883309-0856-4371-BFC3-68E2F54B5B29@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BB883309-0856-4371-BFC3-68E2F54B5B29@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:55:17PM -0500, Kumar Gala wrote:
> It looks like the simplest solution at this point is to unconditionally 
> select the PHYLIB for this board.  We should look at moving the low level 
> mdio bitbang ops out so they can be built as a module.

Or exporting the MDIO/MDC pins through the GPIO API.

-Scott
