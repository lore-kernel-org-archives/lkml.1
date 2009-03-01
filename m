Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZCADyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZCADyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 22:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZCADxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 22:53:55 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:39078
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZCADxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 22:53:55 -0500
Date: Sun, 1 Mar 2009 12:53:51 +0900
From: Mattia Dongili <malattia@linux.it>
To: "Almer S. Tigelaar" <almer@gnome.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2.6.29-rc6] sony-laptop.c: Enable special FN key
	combinations for the Sony VAIO SR model
Message-ID: <20090301035351.GC24964@kamineko.org>
References: <1235857044.11958.40.camel@rufio-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235857044.11958.40.camel@rufio-laptop>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.25-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 10:37:24PM +0100, Almer S. Tigelaar wrote:
> This enables the use of the FN + (F5, F6, F9, F10, F12) keys on newer
> Sony VAIO SR laptops. The patch consists of two (minor) additions: one
> that enables recognition of the FN + F9 key, and another that adds the
> VAIO SR to the list of SNC only models (the SR does not have a SPIC).
> Tested (and working) on my own machine.

Thanks a lot, but a different user already submitted something similar a
few days ago. I'll submit this adnd a few others later.

...
> (Apologies: patch mangled on previous sent, corrected here)
> As a sidenote: This is a rather 'trivial' patch, suitable for back
> porting (to drivers/misc/sony-laptop.c for pre-2.6.29 kernel trees). I
> believe many more of the newer Sony VAIO laptops are SNC only. I added
> only the laptop that I could actually test this for though. Anyhow, this
> 'array of SNC-only exceptions' is going to get longer and longer ... we
> will probably have to come up with some more permanent solution to this.

Yes, I know. I was thinking about just calling the extra acpi method
combinations if all of the SN02, SN03 and SN07 methods are available.
For now all the DSDT I received that have them also required the
additional calls.

-- 
mattia
:wq!
