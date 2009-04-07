Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbZDGSWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbZDGSWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 14:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZDGSWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 14:22:13 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49281 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760143AbZDGSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:22:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
Date: Tue, 07 Apr 2009 11:21:57 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Attempt at "stat light" implementation
In-reply-to: <20090407175617.GF31824@shareable.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Jeff Garzik <jeff@garzik.org>, Oleg Drokin <green@linuxhacker.ru>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-id: <20090407182157.GW3204@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20090407062356.GA1336463@fiona.linuxhacker.ru>
 <20090407173248.GC31824@shareable.org> <49DB8F8E.9010605@garzik.org>
 <20090407175617.GF31824@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 07, 2009  18:56 +0100, Jamie Lokier wrote:
> Jeff Garzik wrote:
> > Jamie Lokier wrote:
> > >Once you have fine-grained selection of stat fields - it's natural to
> > >ask why not allow _additional_ stat fields in an future-extensible
> > >fashion?  A few things would be handy sometimes, such as inode
> > >generation number, modification generation number (to detect changes
> > >across reboots), and extra flags indicating COW or other properties.
> > 
> > That's quite an interesting thought...  until you run out of flags, the 
> > stat structure becomes a bit more flexible.
> 
> I suspect at least one other unix or unix-like OS has done this
> already, and it might be worth copying the interface.  But none come to
> mind.

There is one in OS/X called getattrlist, but it is quite complex and
would require attribute handling wildly different than what the kernel
and *nix applications are doing:

http://www.manpagez.com/man/2/getattrlist/

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

