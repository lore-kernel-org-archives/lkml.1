Return-Path: <linux-kernel-owner+w=401wt.eu-S1762352AbZEGRqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762352AbZEGRqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZEGRqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:46:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbZEGRqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:46:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: U Kuehn <ukuehn@acm.org>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Thu, 7 May 2009 19:45:42 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@tuxonice.net>,
       linux-pm@lists.linux-foundation.org, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <4A03129A.90105@acm.org>
In-Reply-To: <4A03129A.90105@acm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071945.45928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, U Kuehn wrote:
> Pavel Machek wrote:
> >> To briefly summarise the advantages to merging TuxOnIce:
> >>
> >> - Support for multiple swap devices
> >> - Support for non-swap (an ordinary file can be used)
> >> - Uses cryptoapi (LZO support, more than 2x speed of uncompressed data!)
> >> - Asynchronous I/O, readahead, multithreaded. Get the maximum throughput
> >>   possible with your hardware.
> >> - Userspace user interface that lets you abort hibernating and abort
> >>   resuming, get nice progress display etc.
> > 
> > All these are either done by uswsusp already, or could be done w/o
> > modifying kernel code.
> > 
> 
> Given that tuxonice DOES work reliably with dm-crypt encrypted swap
> partitions, does uswsusp offer this functionality? Looking into the docs
> on the sourceforge site does not give any information about this point.
> 
> Further, being someone with a crypto background, the userland suspend
> helper does have some issues with the password/key handling:
> 1) no support for keys containing a 0 byte. (cryptsetup can handle this)
> 2) the rsa functionality seems to use the unsound practice to encrypt
> the symmetric key directly without any padding (aka encoding in libgcrypt).
> 
> This is, unfortunately, something really fundamenta...

I'm not sure you're totally correct, but anyway patches are welcome to improve
it.

Also, as you can see from my previous message, I'm not a big fan of fighting
over this once again.  Lets try to work together to do something productive
instead, shall we?

Best,
Rafael
