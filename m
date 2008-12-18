Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752222AbYLRUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbYLRUL5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYLRULn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:11:43 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57934 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYLRULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:11:41 -0500
Date: Thu, 18 Dec 2008 21:13:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] strip generated symbols from *.ko
Message-ID: <20081218201311.GA16647@uranus.ravnborg.org>
References: <49479EDE.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49479EDE.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:28:14AM +0000, Jan Beulich wrote:
> This patch changes the way __crc_ symbols are being resolved from
> using ld to do so to using the assembler, thus allowing these symbols
> to be marked local (the linker creates then as global ones) and hence
> allow stripping (for modules) or ignoring (for vmlinux) them. While at
> this, also strip other generated symbols during module installation.
> 
> One potentially debatable point is the handling of the flags passeed
> to gcc when translating the intermediate assembly file into an object:
> passing $(c_flags) unchanged doesn't work as gcc passes --gdwarf2 to
> gas whenever is sees any -g* option, even for -g0, and despite the
> fact that the compiler would have already produced all necessary debug
> info in the C->assembly translation phase. I took the approach of just
> filtering out all -g* options, but an alternative to such negative
> filtering might be to have a positive filter which might, in the ideal
> case allow just all the -Wa,* options to pass through.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Both patches are encoded so I end up with "=20", "=3D" in the saved file.
Can you please resend as attachment or fix your mailer.

Thanks,
	Sam
