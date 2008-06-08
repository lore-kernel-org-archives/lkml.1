Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYFHUGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYFHUGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYFHUGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:06:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39547 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbYFHUGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:06:45 -0400
Date: Sun, 8 Jun 2008 22:07:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608200727.GA32141@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608094730.GA30098@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 11:47:30AM +0200, Sam Ravnborg wrote:
> This is just a heads up patch if anyone is interested.
> I finally took the time needed to optimize the
> make headers_* targets.

Based on inputs from various people I have now updated the patch.
A proper serie with a few preparational patches will be posted
and they are aiming for kbuild-next.

The patchset:

      kbuild: refactor headers_* targets in Makefile
      kbuild: always unifdef files in headers_install*
      kbuild: drop support of ALTARCH for headers_*
      kbuild: code refactoring in Makefile.headerinst
      kbuild: error out early in make headers_install
      kbuild: optimize headers_* targets

The meat of the patch is in the last patch which contains all
the real improvements.

	Sam
