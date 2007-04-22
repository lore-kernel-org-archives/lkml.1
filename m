Return-Path: <linux-kernel-owner+w=401wt.eu-S1030788AbXDVTkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030788AbXDVTkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030811AbXDVTkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:40:07 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44621 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030788AbXDVTkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:40:06 -0400
Date: Sun, 22 Apr 2007 21:40:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.20 1/14] CRIS architecture update - Build system
Message-ID: <20070422194056.GA17258@uranus.ravnborg.org>
References: <BFECAF9E178F144FAEF2BF4CE739C66803BEEE17@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C66803BEEE17@exmail1.se.axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 09:24:34PM +0200, Mikael Starvik wrote:
> The attached patch improves the CRIS build system by allowing out-of-tree objdir everywhere
I have browsed through the changes and this is in addition a much more readable
set of Makefile's - good work!

I stumbled over this:

+AFLAGS = -traditional
+LD = gcc-cris -mlinux -nostdlib
+LDFLAGS = -T $(obj)/rescue.ld

We have in i386 / x86_64 recently managed to get rid of -traditional.
And it looks a bit strange that you use gcc as linker.

But thats how it was also done before so not a big issue.

>  
> Signed-off-by: Mikael Starvik <starvik@axis.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>


	Sam
