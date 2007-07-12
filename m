Return-Path: <linux-kernel-owner+w=401wt.eu-S934760AbXGLUjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbXGLUjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764074AbXGLUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:39:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36633 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753667AbXGLUjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:39:08 -0400
Date: Thu, 12 Jul 2007 11:38:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/2] Kexec jump: Hibernation image operations
Message-ID: <20070712093808.GF1866@elf.ucw.cz>
References: <1184167834.12556.14.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184167834.12556.14.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-07-11 15:30:34, Huang, Ying wrote:
> This patch make it possible to have multiple implementations of
> hibernation image operations such as write, read, check, etc, and they
> can be switched at run time through writing the
> "/sys/power/hibernation_image_ops". The uswsusp is the default
> implementation.

Umm, so you hook into hibernation_ops, only to run kexec from it?

Would it make more sense to just run kexec manually, maybe with some
parameter saying "prepare devices before"?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
