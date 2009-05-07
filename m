Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZEGXz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZEGXz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbZEGXzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:55:48 -0400
Received: from sandeen.net ([209.173.210.139]:16524 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbZEGXzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:55:47 -0400
Message-ID: <4A037503.1070904@sandeen.net>
Date: Thu, 07 May 2009 18:55:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com> <4A036FBC.9020201@sandeen.net>
In-Reply-To: <4A036FBC.9020201@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

> there are 2 subsequent unlocks for the same inode:
> 
> 1:
> xfs_iunlock: ip ca2304c0 ino 132  flags 0x5

...

> 2:
> xfs_iunlock: ip ca230980 ino 131  flags 0x5


Ugh no, those are 2 different inodes.... I can read, really.  :)  still,
looking into it.

-Eric
