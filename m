Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbXLPV7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbXLPV7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758533AbXLPV7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:59:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38897 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535AbXLPV7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:59:36 -0500
Date: Sun, 16 Dec 2007 23:01:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.24-rc5: Fix build with make O= if the top level Makefile is not present
Message-ID: <20071216220128.GA32614@uranus.ravnborg.org>
References: <200712162250.18291.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712162250.18291.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 10:50:17PM +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> IMHO, something like the patch below is needed to fix builds with "make O=",
> since after commit 18c32dac75b187d1a4e858f3cfdf03e844129f5e
> "kbuild: fix building with O=.. options" the top-level Makefile is no longer
> created automatically if it's not present at all.

Similar patch already sent to Linus.
Can be seen in my fix-kbuild.git tree.

	Sam
