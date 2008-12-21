Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYLUPEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYLUPEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYLUPDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:03:05 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44696 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYLUPDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:03:04 -0500
Date: Sun, 21 Dec 2008 16:03:02 +0100
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: linux ext3 partition hosed, is this hardware of software error?
Message-ID: <20081221150302.GA3457@gamma.logic.tuwien.ac.at>
References: <20081221143640.GF1509@gamma.logic.tuwien.ac.at> <20081221144913.76ca53d3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221144913.76ca53d3@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On So, 21 Dez 2008, Alan Cox wrote:
> >          res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
> > ata1.00: status: { DRDY ERR }
> > ata1.00: error: { UNC }
> 
> Bad sectors

Umpf. 4 month old. INcredible rubbish.

> > Buffer I/O error on device sda3, logical block 12
> > Buffer I/O error on device sda3, logical block 13
> 
> Right near the start of the disk.

Ah, that is the reason why grub is gone.

> Make a copy of the partition with a recovery tool and write it somewhere

ddrescue? partimage? Any other suggestion?

> (file on another disk whatever) and keep it safe. Make a copy of that and
> fsck the copy. You may need to use the alternate superblock option on
> fsck for this.

Thanks, good hint, didn't know about that.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
MALIBU (n.)
The height by which the top of a wave exceeds the height to which you
have rolled up your trousers.
			--- Douglas Adams, The Meaning of Liff
