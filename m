Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXFJRIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXFJRIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXFJRIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:08:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXFJRIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:08:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.22-rc regression: s2ram fails to suspend + fails to resume w/ Xorg
Date: Sun, 10 Jun 2007 19:14:09 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <1181493847.4503.11.camel@localhost>
In-Reply-To: <1181493847.4503.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101914.09668.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 10 June 2007 18:44, Soeren Sonnenburg wrote:
> Dear all,
> 
> I noticed 2 regressions to 2.6.21.X on my macbook pro:
> 
> 1. on git-current something broke s2ram completely, i.e. s2ram does not
> even suspend anymore but hangs (blinking cursor on console)
> 
> 2. while on -rc3 s2ram is putting the machine to sleep and even makes it
> reliably come back under console, it fails miserably *to resume* when I
> am in X. as this is a ATI binary only X driver (no binary module
> loaded!) I am now not sure whether this report is worth anything. but
> yes it works even with the fglrx module loaded in 2.6.21.X ...
> 
> any ideas / things to try ?

It would be most helpful if you could carry out a binary search for the patch
that broke it.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
