Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbXKMOXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbXKMOXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXKMOW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:22:58 -0500
Received: from gmp-eb-mail-2.sun.com ([192.18.6.24]:47614 "EHLO
	gmp-eb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbXKMOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:22:57 -0500
X-Greylist: delayed 769 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 09:22:57 EST
Date: Tue, 13 Nov 2007 17:09:46 +0300
From: Alex Tomas <bzzz.tomas@gmail.com>
Subject: Re: [PATCH] ext4: dir inode reservation V3
In-reply-to: <4739B0C0.3060907@suse.de>
To: coyli@suse.de
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <4739B02A.2000209@gmail.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4739B0C0.3060907@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070302
 Fedora/1.5.0.10-1.fc6 pango-text Thunderbird/1.5.0.10 Mnenhy/0.7.5.666
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hmm. so you trade 265% degradation of creation for 40% improvement of unlink?

thanks, Alex

Coly Li wrote:
> 			normal ext4			ext4 with dir inode reservation
> 	mount options:	-o data=writeback		-o data=writeback,dir_ireserve=low
> 	Create dirs:	real    0m49.101s		real    2m59.703s
> 	Create files:	real    24m17.962s		real    21m8.161s
> 	Unlink all:	real    24m43.788s		real    17m29.862s
> Creating dirs with dir inode reservation is slower than normal ext4 as predicted, because allocating
> directory inodes in non-linear order will cause extra hard disk seeking and block I/O. Creating
> files with dir inode reservation is 13% faster than normal ext4. Unlink all the directories and
> files is 29.2% faster as expected.
> When number of directories is increased, the performance improvement will be more considerable. More
> benchmark result will be posted here if necessary, because I need more time to run more test cases.

