Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYJDSZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYJDSZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 14:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYJDSZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 14:25:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44388 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYJDSZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 14:25:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.27-rc7, freezes with > 1 s2ram cycle
Date: Sat, 4 Oct 2008 20:29:41 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <1222687747.25190.9.camel@localhost>
In-Reply-To: <1222687747.25190.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810042029.41746.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 29 of September 2008, Soeren Sonnenburg wrote:
> Dear all,
> 
> my macbook pro1,1 works rock solid with -rc7 when it is freshly booted.
> However as soon as I perform a suspend to ram + wakeup cycle, it might
> freeze in the middle of some operation (e.g. backup or updatedb etc).
> 
> This is now with all the drivers being open source (xorg-ati, ath5k) but
> exactly what I was observing before when only the closed source drivers
> were available (so this is not a regression but a long standing bug > 1
> year now).
> 
> Is anyone else observing this or has an idea how to isolate the problem?

Can you please try the patch at
http://marc.info/?l=linux-kernel&m=122307130419753&w=4

Thanks,
Rafael
