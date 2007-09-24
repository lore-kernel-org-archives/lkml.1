Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbXIXRPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbXIXRPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXIXROx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:14:53 -0400
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:54121 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757475AbXIXROw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:14:52 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Antoine Martin <antoine@nagafix.co.uk>
Subject: Re: bug in fsck or ext2/ext3?
Date: Mon, 24 Sep 2007 18:14:40 +0100
User-Agent: KMail/1.9.7
Cc: tytso@thunk.org, Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <46F7EC47.9010803@nagafix.co.uk>
In-Reply-To: <46F7EC47.9010803@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241814.40685.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 September 2007 17:56:39 Antoine Martin wrote:
> Hi Ted / LKML,
>
> I've got this snapshot of an ext3 filesystem with a directory that
> simply cannot be removed! (image below is just 1.2MB)
> As root:
> # wget http://users.nagafix.co.uk/~antoine/root-broken.bz2
> # bunzip2 root-broken.bz2
> # mount -o loop -t ext2 root-broken ./tmp
> # rm -fr tmp/chroot.broken
> rm: cannot remove directory (...)
> Same result when trying to do anything to those files chown/chmod/touch:
> "Operation not permitted"
>
> Tested with e2fsprogs v1.39 on 3 systems.
> Not sure where else to post this...

URL is broken. Tried doing a "lsattr" to ensure no xattrs (like +i) are set?

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

