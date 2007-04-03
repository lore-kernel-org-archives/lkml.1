Return-Path: <linux-kernel-owner+w=401wt.eu-S966123AbXDCART@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966123AbXDCART (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966125AbXDCARS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:17:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:54471 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966124AbXDCARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:17:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tBeq3/WwBi2bDoxFTVwYxo/qkPxON37ZKQVXsDuw/pCZ5NfI9zNN9OLjCSC9Tqt6AY0smGyA2Mj4pGVjv2CoghKteaQTYKjt2YxltWUHQa7gxK6Dck99iKApH+I04aEbGryTY8WEyJvC2oLoMm79lNyLTBP4g3m0uT7MHjMm58g=
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <Pine.LNX.4.61.0704022108190.17673@yvahk01.tjqt.qr>
References: <46110F88.5040905@gmail.com>
	 <Pine.LNX.4.61.0704022108190.17673@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 08:16:21 +0800
Message-Id: <1175559381.7267.15.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 21:10 +0200, Jan Engelhardt wrote:
> On Apr 2 2007 22:13, Antonino A. Daplas wrote:
> >Resetting the console, either by ANSI escape sequences or by the reset utility,
> >will drop the console back to legacy (non-UTF-8) mode. Fix this by leaving the
> >field vc_data.vc_utf untouched in reset_terminal(). In addition, a global
> >variable (default_utf8) which defines system-wide UTF-8 setting is created.
> >This variable can be adjusted via sysfs.
> >
> >This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.
> >
> >Signed-off-by: Antonino Daplas <adaplas@gmail.com>
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> 
> >---
> >
> > drivers/char/vt.c |    4 +++-
> > 1 files changed, 3 insertions(+), 1 deletions(-)
> 
> 
> BTW. Is it feasible to make utf8 the default (static int default_utf8 = 1)
> or is that likely to break some installs?

I guess it would, but most if not all major distribs are moving/have
moved to utf-8.

Tony


