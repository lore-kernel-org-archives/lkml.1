Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYIAL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYIAL7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYIAL7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:59:04 -0400
Received: from enyo.dsw2k3.info ([195.71.86.239]:40370 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbYIAL7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:59:03 -0400
X-Greylist: delayed 1832 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2008 07:59:03 EDT
Date: Mon, 1 Sep 2008 13:28:16 +0200
From: Matthias Schniedermeyer <ms@citd.de>
To: qxc@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: udev and inotify
Message-ID: <20080901112816.GA27059@citd.de>
References: <S1753064AbYIAJYb/20080901092431Z+302@vger.kernel.org> <20080901093201.105550@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901093201.105550@gmx.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.2008 11:32, qxc@gmx.de wrote:
> Hi,
> 
> after I have tried it in different webboards and also in different mailing lists from vger.kernel.org without success I afraid I have to ask my question here (guessing that it is definitely the wrong mailing list):
> 
> I have compiled a special kernel without inotify and dnotify because the target system is very static and doesn't needs them (but kernel size is important on that system).
> 
> Unfortunately now I get an error message from udev that inotify is missing and therefore udev can't check if its cofiguration files change (what never will happen on that system).
> 
> So my question is: how do I get rid of that error message? Can I set a udev option somewhere that turns it off? It is verty irritating for users because it displays an error that is no error...

After locking into the source.
udevd.c, main-function.
Just look for the "inotify_init". It's the if/else if/else after that

The error-message doesn't depend on any further conditions.
If you want to get rid of it, you have to patch it out, getting rid of 
the else if and else should to the trick.





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

