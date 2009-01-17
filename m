Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbZAQVGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbZAQVGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762118AbZAQVGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:06:25 -0500
Received: from sandeen.net ([209.173.210.139]:18941 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992AbZAQVGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:06:24 -0500
Message-ID: <4972484E.5030204@sandeen.net>
Date: Sat, 17 Jan 2009 15:06:22 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Alessandro Bono <alessandro.bono@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-xfs <linux-xfs@oss.sgi.com>
Subject: Re: kernel 2.6.28 XFS internal error xfs_da_do_buf(2) at line 2112
 of	file fs/xfs/xfs_da_btree.c
References: <1232225359.8845.198.camel@champagne.cantina>
In-Reply-To: <1232225359.8845.198.camel@champagne.cantina>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alessandro Bono wrote:
> Hi all
> 
> New kernel new problem
> rsync over ssh to a usb disk get this scary message
> 
> Jan 17 17:39:50 champagne kernel: [30342.675488] 00000000: e8 1f 67 a1
> 7f 9c 65 fc c7 e9 c7 3f e1 d7 17 a7  ..g...e....?....
> Jan 17 17:39:50 champagne kernel: [30342.675504] Filesystem "sdb1": XFS
> internal error xfs_da_do_buf(2) at line 2112 of file
> fs/xfs/xfs_da_btree.c.  Caller 0xffffffffa0196e9f

This means that it read metadata with a bad magic number (the message
could be clearer).

Any storage errors in dmesg prior to this?

-Eric
