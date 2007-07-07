Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbXGGOuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbXGGOuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 10:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXGGOuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 10:50:44 -0400
Received: from lixom.net ([66.141.50.11]:54108 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXGGOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 10:50:43 -0400
Date: Sat, 7 Jul 2007 10:01:47 -0500
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Message-ID: <20070707150147.GA2202@lixom.net>
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707094852.9473.21013.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 01:48:52PM +0400, Vitaly Bordug wrote:
> 
> This adds support for MMIO IDE device like CompactFlash 
> in TrueIDE mode.

Doesn't this duplicate most of pata_platform, but as the
no-longer-preferred legacy IDE device? Did you try using
pata_platform instead?


-Olof
