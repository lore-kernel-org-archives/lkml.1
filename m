Return-Path: <linux-kernel-owner+w=401wt.eu-S1030353AbXBZRWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030353AbXBZRWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030349AbXBZRWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:22:07 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:33870 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030353AbXBZRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OEtSRqbeu/NAEmB+5q4/h4eYY37cb3hRaX/BzWkKtCWA0a8aSi0+PeZOzfOvpv/3evqYu6sQ2q7EF4d54TyXngBGvfn/57IN2j2FCM4s6qEFJBGHG5E8QkGhFPKoPEecRtHuAhTy1r/nQ+hMffFsX6zNmf5ya09dkeUa7YPRHXU=
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: DervishD <lkml@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
In-Reply-To: <20070226171334.GB13496@DervishD>
References: <20070226144744.GA3615@DervishD>
	 <1172503471.20842.14.camel@daplas>  <20070226171334.GB13496@DervishD>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 01:24:14 +0800
Message-Id: <1172510654.7101.11.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 18:13 +0100, DervishD wrote:
>     Hi Antonino :)
> 
>  * Antonino A. Daplas <adaplas@gmail.com> dixit:
> > On Mon, 2007-02-26 at 15:47 +0100, DervishD wrote:
> > >     From time to time, the tdfxfb driver from 2.6.19.5 (sorry, I cannot
> > > test in 2.6.20.x because it doesn't compile, the infamous BDF negative
> > > offset problem) garbles the display, leaving only a lot of thin lines,
> > > just like sync was lost. The display can be repaired by switching to
> > > another console, but this is annoying. This happens with a Voodoo 3
> > > 3000, using 800x600x8@100 mode.
> > 
> > Try fbset -a -vyres 600 first and let us know of the result.
> 
>     After doing this, I no longer can garble the display (before, just a
> "ls -lR /" was enough to do it, in fact, any big output garbled the
> display). The only problem with this solution is that the scroll speed
> has decreased a bit. In fact, the scroll speed is affected by the vyres
> parameter a lot! The highter the vyres, the faster the scroll, and I
> cannot reproduce the problem anymore after changing it once!

Display panning is what makes scrolling fast which is the default scroll
method if vyres > yres.  Unfortunately, tdfxfb occasionally have
problems with this method, the higher the vyres, the greater the
likelihood of screen corruption. That's why tdfxb limits the vyres to a
maximum of 4096. As to why the problem disappeared just by changing this
parameter, that I too don't know.

Tony


