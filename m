Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbYARGOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbYARGOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYARGOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:14:41 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51055 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYARGOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:14:40 -0500
Message-ID: <479043CA.90002@linux.vnet.ibm.com>
Date: Fri, 18 Jan 2008 11:44:34 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org,
       linux-kbuild@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Build Failure at scripts/mkubooting/crc32.c
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails with following error message

scripts/mkubootimg/crc32.c:15:18: error: zlib.h: No such file or directory
scripts/mkubootimg/crc32.c:77: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'crc_table'
scripts/mkubootimg/crc32.c:153: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'crc32'
make[2]: *** [scripts/mkubootimg/crc32.o] Error 1
make[1]: *** [scripts/mkubootimg] Error 2
make: *** [scripts] Error 2

The patch causing this build failure may be git-kbuild.patch.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
