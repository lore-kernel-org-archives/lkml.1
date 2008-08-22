Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYHVRUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYHVRUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYHVRUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:20:23 -0400
Received: from lazybastard.de ([212.112.238.170]:42580 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYHVRUX (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:20:23 -0400
Date: Fri, 22 Aug 2008 19:19:59 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, jaredeh@gmail.com,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Message-ID: <20080822171959.GA30977@logfs.org>
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de> <48AE22F5.3000309@lougher.demon.co.uk> <200808221200.26052.arnd@arndb.de> <48AEF2A3.7020905@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48AEF2A3.7020905@lougher.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 August 2008 18:08:51 +0100, Phillip Lougher wrote:
> 
> Squashfs stores significantly more metadata than cramfs.  Remember 
> cramfs has no support for filesystems > ~ 16Mbytes, no inode timestamps, 
> truncates uid/gids, no hard-links, no nlink counts, no hashed 
> directories,  no unique inode numbers.  If Squashfs didn't compress the 
> metadata it would be significantly larger than cramfs.

Elsewhere in this maze of threads Arnd claimed to have tested the
benefits of metadata compression - and it making little impact.

My guess is that it would make a large impact if metadata would be a
significant part of the filesystem image.  Usually metadata is close
enough to 0% to be mistaken for statistical noise.  So compressing it
makes a significant impact on an insignificant amount of data.

Jörn

-- 
One of my most productive days was throwing away 1000 lines of code.
-- Ken Thompson.
