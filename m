Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYATPat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYATPat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 10:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYATPak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 10:30:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:42072 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbYATPaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 10:30:39 -0500
Date: Sun, 20 Jan 2008 15:30:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Build Failure at scripts/mkubooting/crc32.c
Message-ID: <20080120153035.GA29142@csn.ul.ie>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <479043CA.90002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <479043CA.90002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/01/08 11:44), Kamalesh Babulal didst pronounce:
> Hi Andrew,
> 
> The kernel build fails with following error message
> 
> scripts/mkubootimg/crc32.c:15:18: error: zlib.h: No such file or directory
> scripts/mkubootimg/crc32.c:77: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'crc_table'
> scripts/mkubootimg/crc32.c:153: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'crc32'
> make[2]: *** [scripts/mkubootimg/crc32.o] Error 1
> make[1]: *** [scripts/mkubootimg] Error 2
> make: *** [scripts] Error 2
> 
> The patch causing this build failure may be git-kbuild.patch.
> 

A dependency on zlib was introduced by that patch. I installed
zlib1g-dev but I see that this is expected to be fixed without internal
dependencies anyway.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
