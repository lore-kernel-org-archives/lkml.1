Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbXETKUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbXETKUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbXETKUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:20:36 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46760 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbXETKUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:20:35 -0400
Date: Sun, 20 May 2007 12:21:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.22-rc1-mm1
Message-ID: <20070520102132.GB22091@uranus.ravnborg.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705201212.50810.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705201212.50810.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 12:12:50PM +0200, Mariusz Kozlowski wrote:
> Hello,
> 
> 	I tried it on iMac G3. I got a bunch of warnings
> and finally it failed to build.
> 
> WARNING: "fee_restarts" [arch/powerpc/kernel/built-in] is COMMON symbol
> WARNING: "ee_restarts" [arch/powerpc/kernel/built-in] is COMMON symbol
> WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from dt_string_start (offset 0x8)
....

Most - but not all of these warnings should be gone when
Linus pulls kbuild-fix.git.
When -rc3 is ready can you then please post the result of a build.
Then I can take a look at the remaining section mismatch warnings.

	Sam
