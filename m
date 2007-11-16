Return-Path: <linux-kernel-owner+w=401wt.eu-S1765205AbXKPLl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765205AbXKPLl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbXKPLlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:41:49 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:39528 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029AbXKPLls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:41:48 -0500
Date: Fri, 16 Nov 2007 13:43:20 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig: ARCH=x86
Message-ID: <20071116124320.GB12086@devil>
References: <20071116111446.GA16968@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116111446.GA16968@devil>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 12:14:46PM +0100, Andreas Herrmann wrote:
> BTW, is the x86 kernel build documented somewhere?
> At a first glance I didn't find anything suitable under Documentation/.
> Maybe some explanation (like the above) should be added there.

When the ARCH=x86 build is documented, some words about
cross-compilation should be added:

  (1) To compile a 32-bit kernel on a 64-bit system you have to
  Disable 64bit support in menuconfig (config, oldconfig etc.).  A
  subsequent kernel compile will build a 32-bit kernel.  No cross
  compiler is needed.

  (2) To compile a 64-bit kernel on a 32-bit system you have to switch
  on 64-bit support in menuconfig (or config, oldconfig, etc.).  For
  the subsequent kernel compile a cross compiler (supporting 64-bit)
  is needed. You have to use a command line like

        # make CROSS_COMPILE=x86_64-pc-linux-gnu-

  to cross compile your kernel.


Regards,

Andreas

