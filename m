Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZIKWfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZIKWfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbZIKWfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:35:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757131AbZIKWfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:35:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Date: Sat, 12 Sep 2009 00:36:41 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20090903232317.GA6760@lst.de> <c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com> <m3eiqdqfnm.fsf@pullcord.laptop.org>
In-Reply-To: <m3eiqdqfnm.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909120036.41725.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 September 2009, Chris Ball wrote:
> Hi,
> 
>    > Well system could check basic card ids if they match after resume
> 
> No.  That (arguably) guarantees that it's the same card, but not that
> it wasn't modified in another machine during the suspend.

Generally speaking, we'd also need to check superblocks for this to work.
 
>    > if some users wants to crash his card by randomly swapping it
>    > during suspend/resume - I'd have no problem with that....
> 
> You should have a problem with it.  Taking a card from a suspended
> machine and working on it with a different machine is not a bizarre
> thing to want to do.

Agreed.

Thanks,
Rafael
