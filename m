Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbXETNSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbXETNSu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbXETNSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:18:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910AbXETNSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:18:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Linux 2.6.22-rc2: make -j makes it unresponsive
Date: Sun, 20 May 2007 15:23:55 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org> <200705201457.26716.rjw@sisk.pl> <m3hcq7k5ss.fsf@maximus.localdomain>
In-Reply-To: <m3hcq7k5ss.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705201523.55981.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 20 May 2007 15:01, Krzysztof Halasa wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Running 'make -j' kernel compilation on my test box (Athlon64 X2, 2 SATA
> > drives
> > with 6 software RAID1 ext3 and reiserfs partitions, 2 GB of RAM) makes it
> > completely unresponsive.  I can't even move the mouse pointer when it's
> > running, I can't log to the box from the network etc.
> 
> How many processes does it spawn? Try some sane limit.

Do you think it works as a fork bomb?  Well, it didn't work like that before,
AFAIR, but then 2.6.21 also does it with the same settings, so sorry for the
noise.

Greetings,
Rafael
