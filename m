Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYJQWsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYJQWsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYJQWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:48:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbYJQWs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:48:26 -0400
Date: Fri, 17 Oct 2008 15:47:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6-git
In-Reply-To: <20081017220027.GA3659@kroah.com>
Message-ID: <alpine.LFD.2.00.0810171544320.3438@nehalem.linux-foundation.org>
References: <20081017220027.GA3659@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Oct 2008, Greg KH wrote:
>
> Here is the big batch of USB patches for your 2.6-git tree.

I really wish I were to get the occasional _clean_ pull for a change.

f*ck me, but why do people keep adding more and more warnings, and 
apparently not even bother to write clean code? The merge window is no 
excuse for badly written crap.

  drivers/usb/host/ehci-hcd.c: In function ¡ehci_hcd_init¢:
  drivers/usb/host/ehci-hcd.c:1115: warning: label ¡err_debug¢ defined but not used

That particular function is just about the ugliest thing I've ever seen, 
and now it's adding annoying warnings too!

Yeah, I'm grumpy. The quality control during this merge window has been 
absolutely disgusting. I feel like I have to complain about every other 
pull I do, because people feel like another new warning isn't a problem. 
And every single time, the new warning is due to some total crap code.

		Linus
