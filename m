Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbXFRHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbXFRHxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXFRHxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:53:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41994 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbXFRHxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:53:06 -0400
Date: Mon, 18 Jun 2007 09:54:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Message-ID: <20070618075410.GC21222@uranus.ravnborg.org>
References: <200706171854.24763.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706171854.24763.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 06:54:24PM -0400, Mike Frysinger wrote:
> This updates scripts/hdrschecks.sh by grepping for asm() constructs and
> rejecting them in favor of __asm__() in exported headers.

Hi Mike.

I have a new version of hdrcheck in works written in perl
and a bit faster too.
I hope to finish it off this weekend and sent it for review.
Could I ask you to pick it up and add the below test to that version
when it hits mainline - assuming that the other patches has hit mainline too.
I do not want this check before we are clean so we basically use it to
check that noone introduce a bug.

And next time please put some effort in the _why_ part more than the
_how_ part of the changelog.

	Sam
