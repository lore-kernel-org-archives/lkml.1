Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbXFMMtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbXFMMtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbXFMMtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:49:36 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:56801 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826AbXFMMtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:49:35 -0400
Date: Wed, 13 Jun 2007 15:48:43 +0200
From: DervishD <lkml@dervishd.net>
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070613134843.GC1983@DervishD>
Mail-Followup-To: Juergen Beisert <juergen127@kreuzholzen.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <Pine.LNX.4.64.0706110754280.12140@blackbox.fnordora.org> <20070611174223.GB2433@DervishD> <200706112127.42119.juergen127@kreuzholzen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706112127.42119.juergen127@kreuzholzen.de>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 * Juergen Beisert <juergen127@kreuzholzen.de> dixit:
> On Monday 11 June 2007 19:42, DervishD wrote:
> > I know about cheap pendrives that you cannot format even with FAT32, only
> > with FAT16.
> 
> I'm not sure if the price was the reason that they failed with different 
> filesystems. Some kind of wear leveling tries to guess which blocks of the 
> filesystem are in use and which are unused (to avoid wear leveling of unused 
> data).
> But it only works if you are using a filesystem that is "known" by the wear 
> leveling process. If you are using a different one, it fails badly, because 
> it tries to interpret a FAT that does not exists, and destroys your 
> filesystem while the wear leveling process is running.

    That's exactly what I wanted to know! My Kingston Data Traveler is
not exactly cheap (while not a very expensive piece of hardware,
Kingston is known for the quality of its memory devices), so I hope it
likes ext2. I will do a test.

> So if you can use a different filesystem than FAT16/32 on your pendrive, it 
> does not matter what kind of filesystem you are using. The wear leveling 
> process has no clue about it and always "wear leveling" used *and* unused 
> data (means: every block of the whole disk) until it ruins the flash memory.

    But anyway the memory should last long. Even cheap flash memories
with poor wear leveling (if any at all) usually long last. Given that I
won't be writing continuously, wear shouldn't be a problem. I'm going to
use this as a backup copy of my home. Of course, I can use a tarball
too...

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
