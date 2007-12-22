Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXLVIu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXLVIu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbXLVIuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:50:18 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3143 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXLVIuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:50:17 -0500
Subject: Re: [PATCH 1/3] Remove unused dependency
From: Joe Perches <joe@perches.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       trivial@kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
In-Reply-To: <20071222083323.GA22653@uranus.ravnborg.org>
References: <1198306931-5258-1-git-send-email-joe@perches.com>
	 <1198306931-5258-2-git-send-email-joe@perches.com>
	 <20071222083323.GA22653@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 00:50:12 -0800
Message-Id: <1198313412.4895.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-22 at 09:33 +0100, Sam Ravnborg wrote:
> arch/alpha/boot/mixc.c have:
> #include "../../../lib/inflate.c"

Right. thanks.  Sorry for the noise.

Should the makefiles for the sources that include lib/inflate.c
have a dependency similar to arm and alpha?

With:
arch/alpha/boot/misc.c
arch/arm/boot/compressed/misc.c

Without:
arch/cris/arch-v10/boot/compressed/misc.c
arch/cris/arch-v32/boot/compressed/misc.c
arch/h8300/boot/compressed/misc.c
arch/m32r/boot/compressed/misc.c
arch/sh/boot/compressed/misc.c
arch/sh64/boot/compressed/misc.c
arch/x86/boot/compressed/misc_32.c
arch/x86/boot/compressed/misc_64.c
init/do_mounts_rd.c
init/initramfs.c


