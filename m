Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXLGKzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXLGKzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 05:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXLGKy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 05:54:57 -0500
Received: from aun.it.uu.se ([130.238.12.36]:56032 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbXLGKy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 05:54:56 -0500
Date: Fri, 7 Dec 2007 11:54:38 +0100 (MET)
Message-Id: <200712071054.lB7AscVW002471@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
Subject: Re: NFSv2/3 broken exporting/mounting (permission denied) in 2.6.24-rc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 21:20:41 -0500, Erez Zadok wrote:
> I get a "permission denied" when trying to mount a localhost nfsv2/3
> exported volume, on v2.6.24-rc4-124-gf194d13.  It works w/ nfsv4 mounting.
> It worked fine in 2.6.24-rc3.  Here's a sequence of ops I tried:
> 
> # mount -t ext2 /dev/hdb1 /n/lower/b0
> # exportfs -o no_root_squash,rw localhost:/n/lower/b0
> # mount -t nfs -o nfsvers=3 localhost:/n/lower/b0 /mnt

I'm seeing something similar too. NFSv3 export of an ext3 partition
to another machine in my lan fails (client gets permission denied)
when the server runs 2.6.24-rc4. It worked fine in 2.6.24-rc3.

There's no NFSv4 of any kind on either client or server.
