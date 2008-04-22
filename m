Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbYDVW0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbYDVW0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763594AbYDVWY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:24:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:37785 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763571AbYDVWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:24:56 -0400
Subject: Re: [PATCH 1/3] radeonfb: Fix 64 bits resources on 32 bits archs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com, Hollis Blanchard <hollisb@us.ibm.com>,
       Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>
In-Reply-To: <480E0A54.9010203@linux.vnet.ibm.com>
References: <20080422012723.BA9F2DE13F@ozlabs.org>
	 <480E0A54.9010203@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 08:21:43 +1000
Message-Id: <1208902903.9640.138.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 17:55 +0200, Christian Ehrhardt wrote:
> I wanted to ask if there are any known workarounds atm that would
> allow me to use my X11 for now?

X is doing a mmap of /dev/mem instead of /dev/fb ?

You can normally map the fb mapping /dev/fb and then map the registers
using /dev/fb at an offset beyond the framebuffer (fix->smem_len).

If X is using /dev/mem instead, then it's being stupid and needs to be
fixed...

Cheers,
Ben.


