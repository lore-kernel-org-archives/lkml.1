Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbYG2UWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbYG2UWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYG2UWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:22:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYG2UWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:22:30 -0400
Subject: Re: [PATCH] mISDN cleanup user interface
From: David Woodhouse <dwmw2@infradead.org>
To: Karsten Keil <kkeil@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
In-Reply-To: <20080729195637.GB25929@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 21:22:26 +0100
Message-Id: <1217362946.27925.137.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 21:56 +0200, Karsten Keil wrote:
> Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> 
> The channelmap should have the same size on 32 and 64 bit
> systems. Thanks to David Woodhouse for spotting this.
> 
> Signed-off-by: Karsten Keil <kkeil@suse.de>

Er, isn't that still broken? Consider 32-bit userspace on 64-bit kernel,
big-endian.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



