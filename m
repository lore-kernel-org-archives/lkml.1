Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbYDDG7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbYDDG7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYDDG7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:59:23 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:33298 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbYDDG7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:59:22 -0400
From: Frans Pop <elendil@planet.nl>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Fri, 4 Apr 2008 08:59:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200804021524.27222.elendil@planet.nl> <200804031947.07674.elendil@planet.nl> <20080403193122.GQ24237@csclub.uwaterloo.ca>
In-Reply-To: <20080403193122.GQ24237@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804040859.17187.elendil@planet.nl>
X-OriginalArrivalTime: 04 Apr 2008 06:59:20.0056 (UTC) FILETIME=[67DB1F80:01C89621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008, Lennart Sorensen wrote:
> I am just wondering if arm, m68k, etc might have IDE ports that work
> with ide-generic.  I have no idea to be quite honest.

I plan to mention other arches in the call for testing, so I guess we'll 
find out.

> I can certainly give the installer a shot on my 486, if I can manage to
> boot it somehow.  Any floppy images for the installer around anymore? :)

Of course there are ;-)
http://ftp.debian.org/debian/dists/lenny/main/installer-i386/current/images/floppy/

These use 2.6.22. They don't have the fix I just implemented though. If the 
IDE controller is not detected, try booting the installer with 
hw-detect/load-ide=true
The daily built images, which do have the fix, use 2.6.24, but the increase 
in the size of the kernel causes the boot floppy to be too big so 
installing from floppy is currently not possible. We're working on fixing 
that.

> Do I have to put a disk image on a harddisk and boot from that?

That's an alternative. Use either the netboot or hd-media images for that, 
and it means that you could use a daily image. With the hd-media images 
you'll also need to copy a CD image on the hard disk.

Cheers,
FJP

(Apologies to the list for the somewhat OT post, suggest we follow up 
privately if needed.)
