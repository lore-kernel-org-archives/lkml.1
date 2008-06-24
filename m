Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYFZIVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYFZIVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbYFZITa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:19:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2611 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756487AbYFZITU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:19:20 -0400
Date: Tue, 24 Jun 2008 20:28:17 +0200
From: Pavel Machek <pavel@suse.cz>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/3] Use /proc/firmware_mem for x86 (e820)
Message-ID: <20080624182817.GI5642@ucw.cz>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de> <1213977420-1555-3-git-send-email-bwalle@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213977420-1555-3-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This patch copies the E820 map very early, before the kernel applies various
> operations. That copy is used later to register only the BIOS-provided E820
> map later in the resource tree for /proc/firmware_mem.

It is not process related -> it should not go to /proc. Talk to Greg.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
