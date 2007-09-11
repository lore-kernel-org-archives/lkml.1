Return-Path: <linux-kernel-owner+w=401wt.eu-S1763576AbXIKLyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763576AbXIKLyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXIKLx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:53:59 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:43474 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXIKLx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:53:58 -0400
Date: Tue, 11 Sep 2007 20:53:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] video: uvesafb: Add X86 dependency.
Message-ID: <20070911115346.GA23493@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Paulo Marques <pmarques@grupopie.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Januszewski <spock@gentoo.org>, linux-kernel@vger.kernel.org
References: <20070911081752.GA19495@linux-sh.org> <46E67EFD.2040902@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E67EFD.2040902@grupopie.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 12:41:49PM +0100, Paulo Marques wrote:
> Paul Mundt wrote:
> >uvesafb is x86-specific, reflect that in the Kconfig.
> 
> Hummm... uvesafb _shouldn't_ be x86 specific. At least according to 
> their page [1] where it says: "works on non-x86 systems".
> 
> Uvesafb uses a x86 emulator in userspace to run code from the video card 
> ROM, so it should work on any PCI system where we can access the video 
> card ROM and can emulate the hardware used by the ROM code.
> 
> Why do you say that it's x86 specific? Am I missing something?
> 
The emulator it uses only runs on x86 and x86_64. Thus, it's x86
specific. The v86d and uvesafb pages seem to be in disagremeent, unless
by 'non-x86' it's only implying x86_64.

Additionally, it needs the vga I/O routines, as per vgacon. Most
platforms don't define these.
