Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbXJ1InW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbXJ1InW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 04:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXJ1InI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 04:43:08 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46951 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbXJ1InG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 04:43:06 -0400
Date: Sun, 28 Oct 2007 09:44:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org, torvalds@osdl.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] proc_fs.h redux
Message-ID: <20071028084441.GA24221@uranus.ravnborg.org>
References: <20071027194758.GD9816@martell.zuzino.mipt.ru> <1193524804.26695.103.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193524804.26695.103.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> As a general rule, I think it better to use includes
> than use naked forward declarations.

Quite the opposite - at least in the kernel source.
The general rule is that a .h file shall include the
.h files which contain declarations used by said .h files.
But naked declarations as above is preferred over including
a full header file.

We see the full header dependency thing to blow off when
inline function are used - which is more and more the case.
In several cases we have converted inline functions to macros
just to simplify the nightmare of header dependencies we have.

Arnaldo have a nice script that generate a .ps file
showing all the dependencies.
He lately posted this URL: http://oops.ghostprotocols.net:81/acme/tcp.h.ps

	Sam
