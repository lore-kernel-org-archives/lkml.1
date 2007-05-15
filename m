Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbXEOXAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbXEOXAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756746AbXEOXAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:00:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49539 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbXEOXAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:00:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 16 May 2007 00:59:46 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Fix/add raw1394 CONFIG_COMPAT code
To: Petr Vandrovec <petr@vandrovec.name>
cc: dan@dennedy.org, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070507021447.GA22197@vana.vc.cvut.cz>
Message-ID: <tkrat.a2f16b56bae46a1e@s5r6.in-berlin.de>
References: <20070507021447.GA22197@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  7 May, Petr Vandrovec wrote:
> This patch makes raw1394 in current Linux git tree (2.6.21-1570) usable to 32bit
> applications running on 64bit kernel (tested on i386 app using x86_64 kernel).
[...]
> With this in place I was able to run my test app and grab some mpegs, so I believe
> that I got everything necessary done.  If you believe I have missed some ioctl, yell
> at me.

Petr, thanks once again for the fixes.  I took the liberty to split your
patch into the read(), write(), and ioctl() parts but kept your From:
and Signed-off-by: and Dan's ACK.  Is this OK with you?  I will reply to
this message with
[PATCH 1/3] ieee1394: raw1394: Fix read() for 32bit userland on 64bit kernel
[PATCH 2/3] ieee1394: raw1394: Fix write() for 32bit userland on 64bit kernel
[PATCH 3/3] ieee1394: raw1394: Add ioctl() for 32bit userland on 64bit kernel

I plan to do some own testing on a x86-64 box on Thursday and will then
pass it upstream ASAP.
-- 
Stefan Richter
-=====-=-=== -=-= =----
http://arcgraph.de/sr/

