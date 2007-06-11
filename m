Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbXFKQn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbXFKQn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXFKQnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 12:43:11 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:54360 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXFKQnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 12:43:09 -0400
Date: Mon, 11 Jun 2007 19:42:23 +0200
From: DervishD <lkml@dervishd.net>
To: alan <alan@clueserver.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070611174223.GB2433@DervishD>
Mail-Followup-To: alan <alan@clueserver.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <Pine.LNX.4.64.0706110754280.12140@blackbox.fnordora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0706110754280.12140@blackbox.fnordora.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Alan :)

 * alan <alan@clueserver.org> dixit:
> On Mon, 11 Jun 2007, DervishD wrote:
> >   I was wondering: is there any reason not to use ext2 on an USB
> >pendrive? Really my question is not only about USB pendrives, but any
> >device whose storage is flash based. Let's assume that the device has a
> >good quality flash memory with wear leveling and the like...
> 
> Do you need to use OSes other than Linux?  FAT16/32 seems to be a pretty 
> universal filesystem at this point.  You can mount ext2 on Windows, but it 
> is a pain.  Not certain what it takes to mount it on OS X.

    I don't really need to use ext2, I just was curious. I have a couple
of pendrives and I was thinking about using one of them to store a
"live" copy of my home. So, I wanted ext2 for that. I can access the
data from Windows if I need to, but usually I try not to touch a Windows
even with a 100 mts pole ;)

    Portability (so to speak), is not important for me.

> I have encountered flash drives that do not format well for anything
> other than FAT16, but they were old and small.  Hopefully that problem
> no longer exists with modern hardware.  I would format it then test
> the hell out of it before trusting it with important data.

    That's the answer I was looking for ;))) I mean, will the pendrive
have problems with ext2 due to some strange behaviour of the hardware? I
know about cheap pendrives that you cannot format even with FAT32, only
with FAT16. The pendrive I was considering to have the "live" copy of my
home was a Kingston Data Traveler.

    Of course, I can go with a loopback: this way I'll have a "live"
backup of my home, with all UNIX metadata saved but able to reside on a
FAT16 filesystem. Not very comfortable, given that I won't use it
outside Linux (probably).

    I just was curious about the issue and I was asking to know if
anybody had tried this.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
