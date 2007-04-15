Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbXDOIyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbXDOIyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 04:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXDOIyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 04:54:40 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:3693 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbXDOIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 04:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:from:content-type:mime-version:content-transfer-encoding:date:message-id:user-agent;
        b=Ny7X5efUQl2etUtq1oQe9783rH5Nj4uATgbCTkAWfzo+19sChB+dB2gpp84rJgNr6bMH1WpuAq0DlBUGnK+t2ezJOPyy7z2LwZvhxSIVwQEVdvIVb6tXcUJ6V+Ab6QlduWATcpD1Ta9o9IvkL6vrVJPuT/S7wEcWMQRssyN2Srw=
To: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
From: "David R. Litwin" <presently42@gmail.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Sun, 15 Apr 2007 04:54:13 -0400
Message-ID: <op.tqthonq5ftfxs2@localhost.localdomain>
User-Agent: Opera Mail/9.20 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/07, Neil Brown <neilb@suse.de> wrote:

It is generally expected that email conversations started on-list will
remain on-list, unless there is a special reason to take it off
list... though maybe it was an accident on your part.

It very much was. I'm not used to not being subscribed to a mailing list.

Example of odd commands?
    mkfs -j /dev/whatever
usually does me.  Admittedly it might be nice to avoid the -j, but
that doesn't seem like a bit issue.

Fair enough.

> 2: ZFS provides near-platter speeds. A hard-drive should not be
> hampered performance-wise by it's file system.

That is claimed of XFS too.

Really? I must have missed that one.... Any way, I use XFS so this news  
makes me like it even more.

Immediate backups to tape?  seems unlikely.
Or are you talking about online snapshots.  I believe LVM supports
those.  Maybe the commands there are odd...

O fine, be that way with your commands. :-) As I said, though, I'm not an  
expert. Merely a Linux-user. You know far more about this sort of thing  
than I ever shall.

> 4: ZFS has a HUGE capacity. I don't have 30 exobytes, but I might some
> day....

ext4 will probably cope with that.  XFS definitely has very high
limits though I admit I don't know what they are.

XFS is also a few exobytes.

> 5: ZFS has little over-head. I don't want my file system to take up
> space; that's for the data to do.

I doubt space-overhead is a substantial differentiator between
filesystems.  All filesystems need to use space for metadata.  They
might report it in different ways.

Again, I'm simply reporting what I've heard. Well, read.

>
>   It is possible that that functionality can be
> > incorporated into Linux without trying to clone or copy ZFS.
>
>
> I don't deny this in the least. But, there's good code sitting,waiting  
> to be used. Why bother starting from scratch or trying to
> re-do what is already done?

Imagine someone wanting some cheap furniture and going to a 'garage
sale' at a light-house.  All this nice second-hand furniture, but you
can tell it won't fit in your house as it all has rounded edges...

It is a bit like that with software.  It might have great features and
functionality, but that doesn't mean it will fit.

XFS is a prime example.  It was ported to Linux by creating a fairly
substantial comparability interface so that code written for IRIX
would work in Linux.  That layer makes it a lot harder for other
people to maintain the software (I know, I've tried to understand it
and never got very far).

I've heard of the horrors of XFS's code. But, is there really that much  
work to be done to port ZFS to Linux? This is one area for which I have no  
information, as no one has tried (save the FUSEy folk) due to Lisences. To  
inform me!
- Hide quoted text -

-- 
—A watched bread-crumb never boils.
—My hover-craft is full of eels.
—[...]and that's the he and the she of it.
