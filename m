Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbZDHFku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbZDHFku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760363AbZDHFhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:37:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36574 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760147AbZDHFhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:37:24 -0400
Date: Wed, 8 Apr 2009 00:37:21 -0500
From: Robin Holt <holt@sgi.com>
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Li <benli@broadcom.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc1
Message-ID: <20090408053721.GE10768@sgi.com>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting an ia64 box with a tg3 adapter results in no network.  If I look
at the MAC address of the adapter, it has changed radically from the
original MAC.  The original MAC continues to be reported by EFI and
booting an old kernel gets the correct MAC.

Good MAC:	08:00:69:13:E6:3C
Bad MAC:	00:00:3C:E6:13:69 (recreated from memory)

If I set the MAC using ifconfig, then everything works normally.

Robin
