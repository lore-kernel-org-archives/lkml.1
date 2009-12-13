Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZLML4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZLML4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZLML4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:56:50 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55616 "HELO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752721AbZLML4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:56:49 -0500
Date: Sun, 13 Dec 2009 12:55:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Nir Tzachar <nir.tzachar@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: nconfig v7
Message-ID: <20091213115546.GA10592@merkur.ravnborg.org>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr> <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com> <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >As far as colrs are involved, I think it is best to not impose any
> >color scheme. You can never satisfy everyone, and will get into
> >endless fights about which is best.
> 
> Well, menuconfig seems to have had the least fights. There was exactly 
> one color scheme imposed, and that did not change for years; when themes 
> were added, not much happened. There was a bit of discussion and 
> submissions about themes (including myself), but in the end, it was 
> sort-of agreed upon that four were enough. And they seem to work for 
> everybody.
I also would like the current (menuconfig) defautl color scheme to be used.

> >Thanks for catching this. It is a by-product of the code for
> >presenting everything inside a single menu. Easily fixed in the next
> >version. By the way, is anyone using this option at all? It would much
> >simplify the code if I did not have to support the one giant menu
> >option.
> 
> Well nconfig is the first to provide that option. (Note: I don't use 
> gconfig or xconfig, so I cannot tell if they have something like that.)
> So to see whether there is use, you would have to wait a number of 
> kernel releases that have nconfig integrated.

We already have:
Optional personality available                                        
  . ------------------------------                                     
  . If you prefer to have all of the kernel options listed in a single  
  . menu, rather than the default multimenu hierarchy, run the menuconfig
  . with MENUCONFIG_MODE environment variable set to single_menu. Example:
  .                                                                   
  . make MENUCONFIG_MODE=single_menu menuconfig                        
  .                                                                     
  . <Enter> will then unroll the appropriate category, or enfold it if it
  . is already unrolled.                                                                                                               
  . Note that this mode can eventually be a little more CPU expensive
  . (especially with a larger number of unrolled categories) than the
  . default mode.          

But I do not think it is much used.

	Sam
